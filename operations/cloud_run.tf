
# Allow access to secrets
resource "google_project_iam_member" "cloud_run_secret_iam" {
  member   = "serviceAccount:${data.google_compute_default_service_account.default.email}"
  role     = "roles/secretmanager.secretAccessor"
  project  = var.project
}


# Allow public access to endpoints
locals {
  cloudrun_services = [
    "api-tme",
    "api-tuk",
    # "vue-tme",
    # "vue-tuk",
  ]
}

resource "google_cloud_run_service_iam_member" "default" {
  for_each = toset(local.cloudrun_services)
  location = var.region
  project  = var.project
  service  = each.key
  role     = "roles/run.invoker"
  member   = "allUsers"
}

