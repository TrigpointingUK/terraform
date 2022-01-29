terraform {
  required_version = "~> 1.1"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 4.8"
    }
  }
  backend "gcs" {
    bucket = "trigpointinguk-tfstate"
    prefix = "trigpointinguk-operations"
  }
}

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}

locals {
  terraform_service_account = "terraform@trigpointinguk.iam.gserviceaccount.com"
}

data "google_service_account_access_token" "default" {
  provider               = google.impersonation
  target_service_account = local.terraform_service_account
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1200s"
}

provider "google" {
  project = var.project
  region = var.region
  access_token = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}