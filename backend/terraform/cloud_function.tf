
resource "google_storage_bucket" "function_bucket" {
  name     = "dreambook-cloud-function-bucket"
  location = local.region
}
locals {
  timestamp = formatdate("YYMMDDhhmmss", timestamp())
  root_dir  = abspath("../cloud_function")
}


# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
  type        = "zip"
  source_dir  = local.root_dir
  output_path = "/tmp/function.zip"
}

# Add source code zip to the Cloud Function's bucket
resource "google_storage_bucket_object" "archive" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"

  # Append to the MD5 checksum of the files's content
  # to force the zip to be updated as soon as a change occurs
  name   = "src-${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.function_bucket.name

  # Dependencies are automatically inferred so these lines can be deleted
  depends_on = [
    google_storage_bucket.function_bucket, # declared in `storage.tf`
    data.archive_file.source
  ]
}

resource "google_cloudfunctions2_function" "request_handler" {
    name = "dreambook-request-handler3"
    location = local.region
    description = "Request handler"

    build_config {
        entry_point = "request_handler"
        runtime = "python39"
        source {
            storage_source {
                bucket = google_storage_bucket.function_bucket.name
                object = google_storage_bucket_object.archive.name
            }
        }
    }
    service_config {
        max_instance_count = 2
        available_memory = "256M"
        timeout_seconds = 60
    }
}

output "function_uri" {
      value = google_cloudfunctions2_function.request_handler.service_config[0].uri
}