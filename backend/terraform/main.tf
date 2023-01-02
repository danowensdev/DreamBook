
provider "google" {
  project = local.project_name
  region  = local.region
}


provider "google-beta" {
  project = local.project_name
  region  = local.region
}