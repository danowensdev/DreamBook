resource "google_project" "project" {
  billing_account = local.billing_account
  name            = local.project_name
  project_id      = local.project_name
}


resource "google_project_service" "project" {
  project  = local.project_name
  for_each = toset(local.services_to_enable)
  service  = each.value

  disable_dependent_services = true
  depends_on = [
    google_project.project
  ]
}
