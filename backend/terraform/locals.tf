resource "random_integer" "default" {
  min = 1
  max = 999
}

locals {
  billing_account = "01F21A-6DB229-1099DA"
  service         = "dreambook"
  project_name    = "dreambook-${random_integer.default.result}"
  region          = "europe-west4"
  zone            = "europe-west4-a"

  services_to_enable = [
    "firestore.googleapis.com",
    "cloudbuild.googleapis.com",
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudfunctions.googleapis.com",
    "logging.googleapis.com",
    "compute.googleapis.com",
    "secretmanager.googleapis.com",
    "storage.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}
