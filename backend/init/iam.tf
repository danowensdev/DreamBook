resource "google_project_iam_member" "project" {
  for_each = toset([
    "owner",
    "cloudbuild.builds.builder",
    "cloudfunctions.admin",
    "storage.admin",
    "iam.securityAdmin",
    "logging.admin",
    "monitoring.admin",
    "secretmanager.admin",
    "iam.serviceAccountAdmin",
  ])

  project = google_project.project.project_id
  role   = "roles/${each.value}"

  member = local.admin_user
}