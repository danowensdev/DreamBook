terraform {
  backend "gcs" {
    bucket = "danowensdev-state-1-bucket"
    prefix = "dreambook"
  }
}
