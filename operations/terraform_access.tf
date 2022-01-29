# State bucket
resource "google_storage_bucket" "tfstate" {
  name          = "${var.project}-tfstate"
  storage_class = "MULTI_REGIONAL"
  location      = var.multiregion

  versioning {
    enabled = "true"
  }
}

# Terraform account
resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "Terraform accoount"
}

# Grant rights to terraform account
locals {
  terraform_project_roles = [
    "roles/owner",
  ]
}

resource "google_project_iam_member" "terraform_project_roles" {
  for_each = toset(local.terraform_project_roles)
  member   = "serviceAccount:${google_service_account.terraform.email}"
  project  = var.project
  role     = each.key
}

# Permit impersonation by admin users
resource "google_service_account_iam_binding" "admin-account-iam" {
  service_account_id = google_service_account.terraform.name
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = var.terraform_impersonators
}

resource "google_storage_bucket_iam_member" "member" {
  for_each = toset(var.terraform_impersonators)
  bucket   = google_storage_bucket.tfstate.name
  role     = "roles/storage.admin"
  member   = each.key
}