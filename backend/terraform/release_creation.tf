locals {
  repository = "danowensdev/DreamBook"
}



# Create a service account for the agent to use to create releases
resource "google_service_account" "release_creation" {
    account_id = "release-creation"
    display_name = "Release creation"
}

# Create a bucket for cloud build to store logs and staging (so we can give permissions to it)
resource "google_storage_bucket" "cloud_build" {
  name          = "${local.project_name}-cloud-build"
  location      = local.region
  project       = google_project.project.project_id
}

# Give the release creation SA permission to access the cloud build bucket (for logging and staging)
resource "google_storage_bucket_iam_binding" "cloud_build_bucket" {
  bucket = google_storage_bucket.cloud_build.name
  role   = "roles/storage.admin"
  members = ["serviceAccount:${google_service_account.release_creation.email}"]
}
resource "google_secret_manager_secret_iam_member" "pw_member" {
  project   = google_secret_manager_secret.huggingface-cli-pw.project
  secret_id = google_secret_manager_secret.huggingface-cli-pw.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.release_creation.email}"
}

resource "google_project_iam_member" "cloud_build_editor" {
  project   = google_project.project.project_id
  role      = "roles/cloudbuild.builds.editor"
  member    = "serviceAccount:${google_service_account.release_creation.email}"
}

resource "google_project_iam_member" "artifact_registry_admin" {
  project   = google_project.project.project_id
  role      = "roles/artifactregistry.admin"
  member    = "serviceAccount:${google_service_account.release_creation.email}"
}

# Give the release creation service account permission to access the cloud build bucket (for logging)
resource "google_project_iam_member" "example" {
  project   = google_project.project.project_id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.release_creation.email}"
}

resource "google_project_iam_member" "global_viewer" {
  project   = google_project.project.project_id
  role   = "roles/viewer"
  member = "serviceAccount:${google_service_account.release_creation.email}"
}

# Connect GitHub runner with the release creation service account on GCP

module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = google_project.project.project_id
  pool_id     = "dreambook-pool"
  provider_id = "dreambook-gh-provider"
  sa_mapping = {
    "release-service-account" = {
      sa_name   = "projects/${google_project.project.project_id}/serviceAccounts/${google_service_account.release_creation.email}"
      attribute = "attribute.repository/${local.repository}"
    }
  }
}

output "provider_name" {
  value = module.gh_oidc.provider_name
}

output "release_creation_service_account_email" {
  value = google_service_account.release_creation.email
}

output "cloud_build_bucket_name" {
  value = google_storage_bucket.cloud_build.name
}