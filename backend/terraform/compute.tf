resource "google_compute_instance_template" "dreambook" {
  name                 = "dreambook-template"
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
    source_image      = "projects/ml-images/global/images/family/common-dl-gpu-debian-10"
    
    auto_delete       = true
    boot              = true
    // TODO: Backup
  }

  network_interface {
    network = "default"
  }

  service_account {
    scopes = ["cloud-platform"]
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

  // TODO: Autohealing
}

resource "google_compute_autoscaler" "foobar" {
  name   = "dreambook-autoscaler"
  zone   = local.zone
  target = google_compute_instance_group_manager.dreambook.id

  autoscaling_policy {
    max_replicas    = 1
    min_replicas    = 0
    cooldown_period = 60

    // TODO: autoscaling metric
  }
}