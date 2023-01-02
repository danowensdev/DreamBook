resource "google_storage_bucket" "state" {
  name          = "${local.project_name}-bucket"
  location      = local.region
  project       = google_project.project.project_id
  versioning {
    enabled = "true"
  }
  lifecycle {
    prevent_destroy = true
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      # An object must meet all these to be deleted
      age                = 30 # days
      num_newer_versions = 10   # always keep at least two backups next to the live version
    }
  }

  depends_on = [
    google_project_service.storage
  ]
}

resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "Terraform"
  project      = google_project.project.project_id
}

resource "google_storage_bucket_iam_member" "storage_admin" {
  bucket = google_storage_bucket.state.name
  role   = "roles/storage.admin"
  for_each = toset(concat(local.admin_users, ["serviceAccount:${google_service_account.terraform.email}"]))
  member = each.value
}

output "state_bucket" {
  value = google_storage_bucket.state.name
}