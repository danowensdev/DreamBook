resource "google_storage_bucket" "output_storage" {
    name     = "dreambook-output-storage"
    location = local.region
    project  = google_project.project.project_id
    
}
resource "google_firebase_storage_bucket" "bucket" {
  provider = google-beta
  project  = google_project.project.project_id
  bucket_id = google_storage_bucket.output_storage.name
}

output "output_storage_bucket" {
    value = google_storage_bucket.output_storage.name
}