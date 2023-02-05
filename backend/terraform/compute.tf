locals {
  image_family = "dreambook-stable-diffusion-test"
}

resource "google_compute_network" "dreambook" {
  name = "dreambook-network"
}
resource "google_compute_subnetwork" "dreambook" {
  name          = "dreambook-subnetwork"
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.dreambook.self_link
  region        = local.region
}

resource "google_compute_firewall" "dreambook" {
  name    = "allow-ssh"
  network = google_compute_network.dreambook.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # Google Cloud https://cloud.google.com/nat/docs/gce-example
}
resource "google_compute_router" "dreambook" {
  name    = "dreambook-router"
  network = google_compute_network.dreambook.name
  region  = local.region
}
module "cloud-nat" {
  source  = "terraform-google-modules/cloud-nat/google"
  version = "~> 2.0"

  project_id                         = google_project.project.project_id
  region                             = local.region
  router                             = google_compute_router.dreambook.name
  name                               = "dreambook-nat"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"
  container = {
    image = "eu.gcr.io/${var.project_id}/${var.service_name}:${var.worker_image_tag}"
    tty : true // Allows starting interactive shell in the container
    stdin : true
  }
  restart_policy = "Always" // TODO: Check
}

data "cloudinit_config" "conf" {
  gzip          = false
  base64_encode = false
  part {
    content  = file("conf.yaml")
    filename = "conf.yaml"
  }
}
resource "google_compute_instance_template" "dreambook" {
  name_prefix          = "dreambook-${substr(var.worker_image_tag, 0, 5)}-"
  description          = "This template is used to create dreambook backend instances."
  instance_description = "Dreambook backend instance"
  project              = google_project.project.project_id

  machine_type = "n1-highmem-2"

  can_ip_forward = false

  scheduling {
    provisioning_model  = "STANDARD" // Set to "SPOT" and preemptible to true to use cheaper preemtible instances
    automatic_restart   = true
    on_host_maintenance = "TERMINATE"
    preemptible         = false
  }

  guest_accelerator {
    type  = "nvidia-tesla-t4"
    count = 1
  }

  // Create a new boot disk from an image
  disk {
    #source_image      = "projects/ml-images/global/images/family/common-dl-gpu-debian-10"
    source_image = module.gce-container.source_image

    auto_delete  = true
    boot         = true
    disk_size_gb = 32
    // TODO: Backup
  }

  metadata = {
    //gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
    user-data                 = "${data.cloudinit_config.conf.rendered}"
  }
  //labels = {
  //container-vm = module.gce-container.vm_container_label
  //}

  network_interface {
    network    = google_compute_network.dreambook.name
    subnetwork = google_compute_subnetwork.dreambook.name
  }
  service_account { // TODO
    scopes = ["cloud-platform",
      "https://www.googleapis.com/auth/compute.readonly",
    "https://www.googleapis.com/auth/devstorage.read_only"]
  }
  lifecycle {
    create_before_destroy = true # https://github.com/hashicorp/terraform-provider-google/issues/1601
  }

  #metadata_startup_script = templatefile("./startup.sh", {})

}


resource "google_compute_target_pool" "dreambook" {
  name   = "dreambook-pool"
  region = local.region
}

resource "google_compute_instance_group_manager" "dreambook" {
  name = "dreambook-instance-group-manager"

  base_instance_name = "dreambook"
  zone               = local.zone

  version {
    instance_template = google_compute_instance_template.dreambook.id
  }

  target_pools = [google_compute_target_pool.dreambook.id]

  // Rolling updates on terraform apply # https://stackoverflow.com/a/74914276/5183812
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_autoscaler" "foobar" {
  name     = "dreambook-autoscaler"
  zone     = local.zone
  target   = google_compute_instance_group_manager.dreambook.id
  provider = google-beta
  autoscaling_policy {
    max_replicas    = 1
    min_replicas    = 0
    cooldown_period = 60
    metric {
      name                       = "pubsub.googleapis.com/subscription/num_undelivered_messages"
      filter                     = "resource.type=\"pubsub_subscription\" AND resource.label.subscription_id=\"open-job-subscription\""
      single_instance_assignment = 1 # Each VM can only handle one job at a time
    }
    scale_down_control {
      time_window_sec = 60
      max_scaled_down_replicas {
        fixed = 10
      }
    }

  }
}

# Allow default GCE SA to access huggingface-cli password  data.google_compute_default_service_account.default.email
resource "google_secret_manager_secret_iam_member" "gce-huggingface-cli-pw" {
  project   = google_secret_manager_secret.huggingface-cli-pw.project
  secret_id = google_secret_manager_secret.huggingface-cli-pw.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${data.google_compute_default_service_account.default.email}"
}


output "image_tag" {
  value = var.worker_image_tag
}
