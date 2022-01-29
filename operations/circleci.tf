
# CircleCI account
resource "google_service_account" "circleci" {
  account_id   = "circleci"
  display_name = "CircleCI accoount"
}

# Grant rights to CircleCI account
locals {
  circleci_project_roles = [
    "roles/artifactregistry.writer",
  ]
}

resource "google_project_iam_member" "circleci_project_roles" {
  for_each = toset(local.circleci_project_roles)
  member   = "serviceAccount:${google_service_account.circleci.email}"
  project  = var.project
  role     = each.key
}

resource "google_service_account_key" "circleci" {
  service_account_id = google_service_account.circleci.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "circleci_environment_variable" "circleci" {
  provider = circleci

  project = "api"
  name    = "GCLOUD_SERVICE_KEY"
  value   = google_service_account_key.circleci.private_key
}