##########
# DATABASE
##########

resource "postgresql_database" "tme" {
  provider = postgresql
  name     = "tme"
}

#######
# USERS
#######
# CLOUD_IAM_SERVICE_ACCOUNT cannot be used because CloudRun's sql proxy does not -enable_iam_login
# https://stackoverflow.com/questions/70024078/connecting-to-cloud-sql-from-cloud-run-via-cloud-sql-proxy-with-iam-login-enable

resource "google_secret_manager_secret" "tme_api" {
  secret_id = "TME_API_PASSWORD"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "tme_api" {
  secret      = google_secret_manager_secret.tme_api.id
  secret_data = file("_password_tme")
}
resource "google_sql_user" "tme_api" {
  name            = "tme_api"
  instance        = data.terraform_remote_state.operations.outputs.postgres_name
  password        = google_secret_manager_secret_version.tme_api.secret_data
  deletion_policy = "ABANDON"
}

########
# GRANTS
########
resource "postgresql_grant" "tme_api_db" {
  database    = postgresql_database.tme.name
  role        = google_sql_user.tme_api.name
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT", "CREATE"]
}

# resource "postgresql_grant" "tme_api_schema" {
#   database    = postgresql_database.tme.name
#   role        = google_sql_user.tme_api.name
#   schema      = "public"
#   object_type = "schema"
#   privileges  = ["CREATE", "USAGE"]
# }

resource "postgresql_grant" "tme_api_tables" {
  database    = postgresql_database.tme.name
  role        = google_sql_user.tme_api.name
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
}
