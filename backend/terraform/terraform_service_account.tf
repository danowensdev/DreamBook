# Workaround: Service account needed to apply Terraform for Firebase Auth
# https://groups.google.com/g/firebase-talk/c/fUB2m4UYG8s/m/iA9xMoG8BQAJ

locals {
    roles = [
        "roles/firebase.admin",
        "roles/storage.admin",
        "roles/viewer",
        "roles/iam.workloadIdentityPoolViewer",
    ]
}

resource "google_service_account" "terraform_applier" {
  account_id   = "terraform-applier"
  display_name = "Terraform applier"
  project      = google_project.project.project_id
}

# Allow admin user to use this service account
resource "google_project_iam_member" "terraform_applier_for_admin" {
  project = google_project.project.project_id
  role    = "roles/iam.serviceAccountUser"
  for_each = toset(local.admin_users)
  member  = each.value
}

# Grant each role to the service account
resource "google_project_iam_member" "terraform_applier_roles" {
  project = google_project.project.project_id
  member  = "serviceAccount:${google_service_account.terraform_applier.email}"
  for_each = toset(local.roles)
  role    = each.value
}

# Give access to the terraform applier service account (admin access)
resource "google_storage_bucket_iam_member" "terraform_applier" {
  bucket = local.state_bucket
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.terraform_applier.email}"
}