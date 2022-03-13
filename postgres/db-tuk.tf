resource "postgresql_database" "tuk" {
  provider = postgresql
  name     = "tuk"
}

resource "postgresql_grant" "tuk_db" {
  database    = postgresql_database.tuk.name
  role        = "tuk"
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT"]
}

resource "postgresql_grant" "tuk_schema" {
  database    = postgresql_database.tuk.name
  role        = "tuk"
  schema      = "public"
  object_type = "schema"
  privileges  = ["CREATE", "USAGE"]
}

resource "postgresql_grant" "tuk_tables" {
  database    = postgresql_database.tuk.name
  role        = "tuk"
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
}
