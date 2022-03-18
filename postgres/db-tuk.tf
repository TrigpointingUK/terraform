##########
# DATABASE
##########

resource "postgresql_database" "tuk" {
  provider = postgresql
  name     = "tuk"
}

#######
# USERS
#######
# CLOUD_IAM_SERVICE_ACCOUNT cannot be used because CloudRun's sql proxy does not -enable_iam_login
# https://stackoverflow.com/questions/70024078/connecting-to-cloud-sql-from-cloud-run-via-cloud-sql-proxy-with-iam-login-enable

resource "google_secret_manager_secret" "tuk_api" {
  secret_id = "TUK_API_PASSWORD"
  replication {
    automatic = true
  }
}
resource "google_secret_manager_secret_version" "tuk_api" {
  secret      = google_secret_manager_secret.tuk_api.id
  secret_data = file("_password_tuk")
}
resource "google_sql_user" "tuk_api" {
  name            = "tuk_api"
  instance        = data.terraform_remote_state.operations.outputs.postgres_name
  password        = google_secret_manager_secret_version.tuk_api.secret_data
  deletion_policy = "ABANDON"
}

########
# GRANTS
########
resource "postgresql_grant" "tuk_api_db" {
  database    = postgresql_database.tuk.name
  role        = google_sql_user.tuk_api.name
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT", "CREATE"]
}

# resource "postgresql_grant" "tuk_api_schema" {
#   database    = postgresql_database.tuk.name
#   role        = google_sql_user.tuk_api.name
#   schema      = "public"
#   object_type = "schema"
#   privileges  = ["CREATE", "USAGE"]
# }

resource "postgresql_grant" "tuk_api_tables" {
  database    = postgresql_database.tuk.name
  role        = google_sql_user.tuk_api.name
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
}
