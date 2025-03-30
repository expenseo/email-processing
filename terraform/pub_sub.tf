resource "google_pubsub_topic" "gmail_topic" {
  name = "gmail-email-events"
}

resource "google_project_iam_binding" "pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  members = [
    "serviceAccount:gmail-api-push@system.gserviceaccount.com"
  ]

}
