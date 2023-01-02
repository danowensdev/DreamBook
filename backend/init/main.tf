resource "google_project" "project" {
  billing_account = local.billing_account
  name            = local.project_name
  project_id      = local.project_name
}

resource "google_project_service" "storage" {
  project  = google_project.project.project_id
  service  = "storage.googleapis.com"

  disable_dependent_services = true
  depends_on = [
    google_project.project
  ]
}
