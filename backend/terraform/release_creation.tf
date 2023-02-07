# TODO: Don't need these roles since we impersonate terraform applier SA
locals {
  repository = "danowensdev/DreamBook"
}

# Create a bucket for cloud build to store logs and staging (so we can give permissions to it)
resource "google_storage_bucket" "cloud_build" {
  name     = "${local.project_name}-cloud-build"
  location = local.region
  project  = google_project.project.project_id
}

data "google_compute_default_service_account" "default" {}


# Connect GitHub runner with the release creation service account on GCP
module "gh_oidc" {
  source      = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  project_id  = google_project.project.project_id
  pool_id     = "dreambook-pool"
  provider_id = "dreambook-gh-provider"
  sa_mapping = {
    "release-service-account" = {
      sa_name   = "projects/${google_project.project.project_id}/serviceAccounts/${google_service_account.terraform_applier.email}"
      attribute = "attribute.repository/${local.repository}"
    }
  }
}

output "provider_name" {
  value = module.gh_oidc.provider_name
}


output "cloud_build_bucket_name" {
  value = google_storage_bucket.cloud_build.name
}
