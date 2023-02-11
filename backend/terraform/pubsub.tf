resource "google_pubsub_topic" "default" {
  name = "open-job-topic"
}
resource "google_pubsub_subscription" "default" {
  name                       = "open-job-subscription"
  topic                      = google_pubsub_topic.default.name
  ack_deadline_seconds       = 300
  retain_acked_messages      = false
  message_retention_duration = "1000s"
}
