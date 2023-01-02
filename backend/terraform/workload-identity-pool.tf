locals {
  repository = "danowensdev/DreamBook"
}

resource "google_service_account" "release_creation" {
    account_id = "release-creation"
    display_name = "Release creation"
}

resource "google_secret_manager_secret_iam_member" "pw_member" {
  project   = google_secret_manager_secret.huggingface-cli-pw.project
  secret_id = google_secret_manager_secret.huggingface-cli-pw.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.release_creation.email}"
}

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
