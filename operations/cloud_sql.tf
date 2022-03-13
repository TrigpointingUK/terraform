resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "trigpointing" {
  name                = "trigpointing-${random_id.db_name_suffix.hex}"
  database_version    = "POSTGRES_14"
  deletion_protection = false
  region              = "europe-west1"
  settings {
    tier              = "db-f1-micro"
    disk_type         = "PD_HDD"
    disk_size         = 10
    disk_autoresize   = false
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    backup_configuration {
      enabled = false
    }
    ip_configuration {
      ipv4_enabled = true
      require_ssl  = true
    }
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
    insights_config {
      query_insights_enabled  = true
      query_string_length     = 1024
      record_application_tags = true
      record_client_address   = true
    }
  }
}
output "postgres_name" {
  value = google_sql_database_instance.trigpointing.name
}
output "postgres_connection_name" {
  value = google_sql_database_instance.trigpointing.connection_name
}
output "postgres_public_ip_address" {
  value = google_sql_database_instance.trigpointing.public_ip_address
}

#######
# USERS
#######

# Superuser
resource "google_secret_manager_secret" "postgres" {
  secret_id = "POSTGRES_PASSWORD"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "postgres" {
  secret      = google_secret_manager_secret.postgres.id
  secret_data = file("_password_postgres")
}

resource "google_sql_user" "postgres" {
  name            = "postgres"
  instance        = google_sql_database_instance.trigpointing.name
  password        = google_secret_manager_secret_version.postgres.secret_data
  deletion_policy = "ABANDON"
}


# tme
# CLOUD_IAM_SERVICE_ACCOUNT cannot be used because CloudRun's sql proxy does not -enable_iam_login
# https://stackoverflow.com/questions/70024078/connecting-to-cloud-sql-from-cloud-run-via-cloud-sql-proxy-with-iam-login-enable

resource "google_secret_manager_secret" "tme" {
  secret_id = "TME_POSTGRES_PASSWORD"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "tme" {
  secret      = google_secret_manager_secret.tme.id
  secret_data = file("_password_tme")
}

resource "google_sql_user" "tme" {
  name            = "tme"
  instance        = google_sql_database_instance.trigpointing.name
  password        = google_secret_manager_secret_version.tme.secret_data
  deletion_policy = "ABANDON"

}



# tuk
# CLOUD_IAM_SERVICE_ACCOUNT cannot be used because CloudRun's sql proxy does not -enable_iam_login
# https://stackoverflow.com/questions/70024078/connecting-to-cloud-sql-from-cloud-run-via-cloud-sql-proxy-with-iam-login-enable

resource "google_secret_manager_secret" "tuk" {
  secret_id = "TUK_POSTGRES_PASSWORD"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "tuk" {
  secret      = google_secret_manager_secret.tuk.id
  secret_data = file("_password_tuk")
}

resource "google_sql_user" "tuk" {
  name            = "tuk"
  instance        = google_sql_database_instance.trigpointing.name
  password        = google_secret_manager_secret_version.tuk.secret_data
  deletion_policy = "ABANDON"
}


# admin
resource "google_sql_user" "admin" {
  name            = "admin@trigpointing.uk"
  instance        = google_sql_database_instance.trigpointing.name
  type            = "CLOUD_IAM_USER"
  deletion_policy = "ABANDON"
}


# # DATABASES
# resource "google_sql_database" "tuk" {
#   name     = "tuk"
#   instance = google_sql_database_instance.trigpointing.name
# }

# resource "google_sql_database" "tme" {
#   name     = "tme"
#   instance = google_sql_database_instance.trigpointing.name
# }
