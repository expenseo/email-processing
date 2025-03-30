resource "google_secret_manager_secret" "gmail_credentials" {
  project   = var.project_id
  secret_id = "gmail-credentials"
  replication {
    auto {}
  }
}
