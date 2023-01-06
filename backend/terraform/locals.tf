resource "random_integer" "default" {
  min = 1
  max = 999
}

locals {
  state_bucket              = "danowensdev-state-1-bucket"
  billing_account           = "01F21A-6DB229-1099DA"
  project_name              = "dreambook-${random_integer.default.result}"
  region                    = "europe-west1"
  zone                      = "europe-west1-d"
  terraform_service_account = "terraform-applier@dreambook-713.iam.gserviceaccount.com"

  services_to_enable = [
    "firebasestorage.googleapis.com",
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
  admin_users = [
    "user:danowens878@gmail.com"
  ]
}
