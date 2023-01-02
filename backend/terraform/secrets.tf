resource "google_secret_manager_secret" "huggingface-cli-pw" {
    project = google_project.project.project_id
    secret_id = "huggingface-pw"
    replication {
        automatic = true
    }
}