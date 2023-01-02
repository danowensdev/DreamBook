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
    ports = ["22"]
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

  project_id = google_project.project.project_id
  region     = local.region
  router     = google_compute_router.dreambook.name
  name   = "dreambook-nat"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

module "gce-container" {
  source = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"
  container = {
    image = var.worker_image_uri
    tty: var.activate_tty // Allows starting interactive shell in the container
    stdin: var.activate_tty
  }
  restart_policy = "Always" // TODO: Check
}

resource "google_compute_instance_template" "dreambook" {
  name_prefix          = "dreambook-${substr(var.worker_image_tag, 0, 5)}-"
  description          = "This template is used to create dreambook backend instances."
  instance_description = "Dreambook backend instance"
  project              = google_project.project.project_id

  machine_type         = "custom-2-13312"
  
  can_ip_forward       = false

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
    source_image      = module.gce-container.source_image
    
    auto_delete       = true
    boot              = true
    // TODO: Backup
  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google_logging_enabled = "true"
  }
  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  network_interface {
    network = google_compute_network.dreambook.name
    subnetwork = google_compute_subnetwork.dreambook.name
  }
  service_account { // TODO
    scopes = ["cloud-platform"]
  }
  lifecycle {
    create_before_destroy = true # https://github.com/hashicorp/terraform-provider-google/issues/1601
  }
}

resource "google_compute_target_pool" "dreambook" {
  name = "dreambook-pool"
}

resource "google_compute_instance_group_manager" "dreambook" {
  name = "dreambook-instance-group-manager"

  base_instance_name = "dreambook"
  zone               = local.zone

  version {
    instance_template  = google_compute_instance_template.dreambook.id
  }

  target_pools = [google_compute_target_pool.dreambook.id]

  // Rolling updates on terraform apply # https://stackoverflow.com/a/74914276/5183812
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_autoscaler" "foobar" {
  name   = "dreambook-autoscaler"
  zone   = local.zone
  target = google_compute_instance_group_manager.dreambook.id
  provider = google-beta
  autoscaling_policy {
    max_replicas    = 1
    min_replicas    = 0
    cooldown_period = 60
    metric {
      name   = "pubsub.googleapis.com/subscription/num_undelivered_messages"
      filter = "resource.type=\"pubsub_subscription\" AND resource.label.subscription_id=\"open-job-subscription\""
      single_instance_assignment = 1  # Each VM can only handle one job at a time
    }
    scale_down_control {
      time_window_sec = 60
      max_scaled_down_replicas {
        fixed = 10
      }
    }
    
  }
}