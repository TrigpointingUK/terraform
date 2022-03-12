resource "google_sql_database_instance" "trigpointing" {
  # name                = "trigpointing"
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
      # authorized_networks {
      #   # name  = "BT ADSL"
      #   # value = "86.165.113.137/32"
      # }
    }
  }
}

output "postgres_public_ip_address" {
  value = google_sql_database_instance.trigpointing.public_ip_address
}

# SSL KEY
resource "google_sql_ssl_cert" "client_cert" {
  common_name = "trigpointing-client"
  instance    = google_sql_database_instance.trigpointing.name
}

output "server_ca" {
  value     = google_sql_ssl_cert.client_cert.server_ca_cert
  sensitive = true
}
output "client_cert" {
  value     = google_sql_ssl_cert.client_cert.cert
  sensitive = true
}
output "cert_expiration" {
  value = google_sql_ssl_cert.client_cert.expiration_time
}


# USERS
resource "google_sql_user" "postgres" {
  name     = "postgres"
  instance = google_sql_database_instance.trigpointing.name
  password = file("_password_postgres")
}

resource "google_sql_user" "ian" {
  name     = "ian"
  instance = google_sql_database_instance.trigpointing.name
  password = file("_password_ian")
}

resource "google_sql_user" "tme" {
  name     = "tme"
  instance = google_sql_database_instance.trigpointing.name
  password = file("_password_tme")
}

resource "google_sql_user" "tuk" {
  name     = "tuk"
  instance = google_sql_database_instance.trigpointing.name
  password = file("_password_tuk")
}


# DATABASES
resource "google_sql_database" "tuk" {
  name     = "tuk"
  instance = google_sql_database_instance.trigpointing.name
}

resource "google_sql_database" "tme" {
  name     = "tme"
  instance = google_sql_database_instance.trigpointing.name
}
