data "google_project" "project" {
}

locals {
  project_services = [
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "dns.googleapis.com",
    "iam.googleapis.com",
    "logging.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com",
    "sql-component.googleapis.com",
    "storage-api.googleapis.com",
    "storage-component.googleapis.com",
  ]
}

resource "google_project_service" "gcp_project_services" {
  count              = length(local.project_services)
  service            = element(local.project_services, count.index)
  disable_on_destroy = true
}

# State bucket
resource "google_storage_bucket" "tfstate" {
  name          = "${var.project}-tfstate"
  storage_class = "MULTI_REGIONAL"
  location      = var.multiregion

  versioning {
    enabled = "true"
  }
}

