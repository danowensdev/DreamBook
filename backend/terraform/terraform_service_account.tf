# Workaround: Service account needed to apply Terraform for Firebase Auth
# https://groups.google.com/g/firebase-talk/c/fUB2m4UYG8s/m/iA9xMoG8BQAJ

locals {
  roles = [
    "roles/pubsub.admin",
    "roles/firebase.admin",
    "roles/storage.admin",
    "roles/viewer",
    "roles/iam.workloadIdentityPoolViewer",

    "roles/compute.admin",                 # For creating, editing and deleting instances and networks
    "roles/cloudbuild.builds.editor",      # For creating builds
    "roles/artifactregistry.admin",        # For pushing to artifact registry
    "roles/storage.objectViewer",          # For logging
    "roles/iam.serviceAccountTokenCreator" # Needed so that the the OIDC connection can create a token from the json key.
  ]
}

resource "google_service_account" "terraform_applier" {
  account_id   = "terraform-applier"
  display_name = "Terraform applier"
  project      = google_project.project.project_id
}

# Allow admin user to use this service account
resource "google_project_iam_member" "admin_terraform_sa_user" {
  project  = google_project.project.project_id
  role     = "roles/iam.serviceAccountUser"
  for_each = toset(local.admin_users)
  member   = each.value
}
resource "google_project_iam_member" "token_creator_admin_terraform_sa" {
  project  = google_project.project.project_id
  role     = "roles/iam.serviceAccountTokenCreator"
  for_each = toset(local.admin_users)
  member   = each.value
}


# Grant each terraform applier role to the service account
resource "google_project_iam_member" "terraform_applier_roles" {
  project  = google_project.project.project_id
  member   = "serviceAccount:${google_service_account.terraform_applier.email}"
  for_each = toset(local.roles)
  role     = each.value
}

# Give access to the terraform applier service account (admin access)
resource "google_storage_bucket_iam_member" "terraform_applier" {
  bucket = local.state_bucket
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.terraform_applier.email}"
}

# Allow SA to use the default GCE account
resource "google_service_account_iam_member" "gce-default-account-terraform-sa" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.terraform_applier.email}"
}


# TODO: Move to `init` module since we need this for the provider
output "terraform_applier_service_account" {
  value = google_service_account.terraform_applier.email
}
