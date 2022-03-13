
locals {
  terraform_service_account = "terraform@trigpointinguk.iam.gserviceaccount.com"
}

terraform {
  required_version = "~> 1.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.8"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.8"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.15.0"
    }

  }
  backend "gcs" {
    bucket                      = "trigpointinguk-tfstate"
    prefix                      = "trigpointinguk-postgres"
    impersonate_service_account = "terraform@trigpointinguk.iam.gserviceaccount.com"
  }
}

provider "google" {
  alias = "impersonation"
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}


data "google_service_account_access_token" "default" {
  provider               = google.impersonation
  target_service_account = local.terraform_service_account
  scopes                 = ["userinfo-email", "cloud-platform"]
  lifetime               = "1200s"
}

provider "google" {
  project         = var.project
  region          = var.region
  access_token    = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}

provider "google-beta" {
  project         = var.project
  region          = var.region
  access_token    = data.google_service_account_access_token.default.access_token
  request_timeout = "60s"
}

provider "postgresql" {
  host     = "localhost"
  username = "postgres"
  password = data.google_secret_manager_secret_version.postgres.secret_data
  sslmode  = "disable"
}

data "google_secret_manager_secret_version" "postgres" {
  secret = "POSTGRES_PASSWORD"
}
