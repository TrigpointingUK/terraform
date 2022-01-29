
# CircleCI account
resource "google_service_account" "circleci" {
  account_id   = "circleci"
  display_name = "CircleCI accoount"
}

# Grant rights to CircleCI account
locals {
  circleci_project_roles = [
    "roles/artifactregistry.writer",
    "roles/run.developer",
  ]
}

resource "google_project_iam_member" "circleci_project_roles" {
  for_each = toset(local.circleci_project_roles)
  member   = "serviceAccount:${google_service_account.circleci.email}"
  project  = var.project
  role     = each.key
}

resource "google_service_account_iam_member" "circleci-compute-iam" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.circleci.email}"
}





# Setup CircleCI project variables

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

locals {
  gcr = "${var.region}-docker.pkg.dev"
  api_tag = "${var.region}-docker.pkg.dev/${var.project}/${google_artifact_registry_repository.images.repository_id}/tuk-api"
}

resource "circleci_environment_variable" "circleci_region" {
  provider = circleci

  project = "api"
  name    = "REGION"
  value   = var.region
}

resource "circleci_environment_variable" "circleci_registry" {
  provider = circleci

  project = "api"
  name    = "GCR"
  value   = local.gcr
}

resource "circleci_environment_variable" "api_tag" {
  provider = circleci

  project = "api"
  name    = "TAG"
  value   = local.api_tag
}


output "api_tag" {
  value = local.api_tag
}
