# resource "google_compute_network" "private_network" {
#   name = "private-network"
# }

# resource "google_compute_global_address" "private_ip_address" {
#   name          = "private-ip-address"
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   prefix_length = 16
#   network       = google_compute_network.private_network.id
# }

# resource "google_service_networking_connection" "private_vpc_connection" {
#   network                 = google_compute_network.private_network.id
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
# }

resource "random_id" "db_name_suffix" {
  byte_length = 4
}


resource "google_sql_database_instance" "trigpointing" {
  name                = "trigpointing-${random_id.db_name_suffix.hex}"
  database_version    = "POSTGRES_14"
  deletion_protection = false
  region              = "europe-west1"
  # depends_on          = [google_service_networking_connection.private_vpc_connection]

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
      # name  = "BT ADSL"
      # value = "86.165.113.137/32"
      # }
      # private_network = google_compute_network.private_network.id
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

# output "postgres_private_ip_address" {
#   value = google_compute_global_address.private_ip_address.address
# }



# SSL KEY
# resource "google_sql_ssl_cert" "client_cert" {
#   common_name = "trigpointing-client"
#   instance    = google_sql_database_instance.trigpointing.name
# }

# output "server_ca" {
#   value     = google_sql_ssl_cert.client_cert.server_ca_cert
#   sensitive = true
# }
# output "client_cert" {
#   value     = google_sql_ssl_cert.client_cert.cert
#   sensitive = true
# }
# output "cert_expiration" {
#   value = google_sql_ssl_cert.client_cert.expiration_time
# }


# USERS
resource "google_sql_user" "postgres" {
  name            = "postgres"
  instance        = google_sql_database_instance.trigpointing.name
  password        = file("_password_postgres")
  deletion_policy = "ABANDON"
}

resource "google_sql_user" "ian" {
  name            = "ian"
  instance        = google_sql_database_instance.trigpointing.name
  password        = file("_password_ian")
  deletion_policy = "ABANDON"
}

resource "google_sql_user" "tme" {
  name            = "tme"
  instance        = google_sql_database_instance.trigpointing.name
  password        = file("_password_tme")
  deletion_policy = "ABANDON"

}

resource "google_sql_user" "tuk" {
  name            = "tuk"
  instance        = google_sql_database_instance.trigpointing.name
  password        = file("_password_tuk")
  deletion_policy = "ABANDON"

}

resource "google_sql_user" "users" {
  name            = "admin@trigpointing.uk"
  instance        = google_sql_database_instance.trigpointing.name
  type            = "CLOUD_IAM_USER"
  deletion_policy = "ABANDON"
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
