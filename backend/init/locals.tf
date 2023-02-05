locals {
  billing_account = "01F21A-6DB229-1099DA"
  project_name    = "danowensdev-state-1"
  region          = "europe-west1"
  zone            = "europe-west1-c"

  services_to_enable = [
    "storage.googleapis.com",
  ]

  admin_user = "user:danowens878@gmail.com"
}
