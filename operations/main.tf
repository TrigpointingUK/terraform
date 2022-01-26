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
  region  = var.region
  project = var.project
}
