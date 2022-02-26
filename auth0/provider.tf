
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

    auth0 = {
      source  = "auth0/auth0"
      version = "0.27.1"
    }
  }
  backend "gcs" {
    bucket                      = "trigpointinguk-tfstate"
    prefix                      = "trigpointinguk-auth0"
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

provider "auth0" {
  domain        = "trigpointing.eu.auth0.com"
  client_id     = file("auth0_clientid")
  client_secret = file("auth0_clientsecret")
  debug         = "true"
}
