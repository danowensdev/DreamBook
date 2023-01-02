terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.47"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.47"
    }
  }
  backend "gcs" {
    bucket = "danowensdev-state-1-bucket"
    prefix = "dreambook"
  }
}
