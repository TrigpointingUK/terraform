resource "google_secret_manager_secret" "pgadmin-config" {
  secret_id = "PGADMIN_CONFIG"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "pgadmin-config" {
  secret      = google_secret_manager_secret.pgadmin-config.id
  secret_data = <<EOT
{
  "Servers": {
    "Trigpointing": {
      "Name": "TrigpointingUK Postgres Cloud SQL server",
      "Group": "Trigpointing",
      "Port": 5432,
      "Username": "postgres",
      "Host": "/cloudsql/${data.terraform_remote_state.operations.outputs.postgres_connection_name}",
      "SSLMode": "disable",
      "MaintenanceDB": "postgres"
    }
  }
}
EOT    
}


resource "google_cloud_run_service" "pgadmin" {
  name     = "pgadmin"
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"      = "0"
        "autoscaling.knative.dev/maxScale"      = "1"
        "run.googleapis.com/cloudsql-instances" = data.terraform_remote_state.operations.outputs.postgres_connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
    spec {
      service_account_name = "api-tme@trigpointinguk.iam.gserviceaccount.com"
      containers {
        image = "europe-west1-docker.pkg.dev/trigpointinguk/images/pgadmin4:6"

        volume_mounts {
          name       = "server_config"
          mount_path = "/mnt/pgadmin4"
        }

        env {
          name  = "PGADMIN_DEFAULT_EMAIL"
          value = "teasel.ian@gmail.com"
        }
        env {
          name  = "PGADMIN_DISABLE_POSTFIX"
          value = "true"
        }
        env {
          name  = "PGADMIN_LISTEN_ADDRESS"
          value = "0.0.0.0"
        }
        env {
          name  = "PGADMIN_LISTEN_PORT"
          value = "80"
        }
        env {
          name  = "PGADMIN_SERVER_JSON_FILE"
          value = "/mnt/pgadmin4/servers.json"
        }

        env {
          name = "PGADMIN_DEFAULT_PASSWORD"
          value_from {
            secret_key_ref {
              name = "POSTGRES_PASSWORD"
              key  = "latest"
            }
          }
        }
        ports {
          container_port = "80"
        }
      }

      volumes {
        name = "server_config"
        secret {
          secret_name = "PGADMIN_CONFIG"
          items {
            key  = "latest"
            path = "servers.json"
          }
        }
      }
    }

  }
  autogenerate_revision_name = true
  lifecycle {
    ignore_changes = [
      metadata.0.annotations,
    ]
  }
}

data "google_iam_policy" "pgadmin" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "pgadmin" {
  location = google_cloud_run_service.pgadmin.location
  project  = google_cloud_run_service.pgadmin.project
  service  = google_cloud_run_service.pgadmin.name

  policy_data = data.google_iam_policy.pgadmin.policy_data
}





