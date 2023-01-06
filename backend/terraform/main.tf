
provider "google" {
  project                     = local.project_name
  region                      = local.region
  zone                        = local.zone
  impersonate_service_account = local.terraform_service_account
}


provider "google-beta" {
  project                     = local.project_name
  region                      = local.region
  zone                        = local.zone
  impersonate_service_account = local.terraform_service_account
}
