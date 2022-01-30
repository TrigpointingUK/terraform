resource "google_artifact_registry_repository" "images" {
  provider = google-beta

  location = var.region
  repository_id = "images"
  description = "TrigpointingUK Docker Images"
  format = "DOCKER"
}