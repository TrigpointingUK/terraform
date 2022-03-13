resource "postgresql_database" "tme" {
  provider = postgresql
  name     = "tme"
}

resource "postgresql_grant" "tme_db" {
  database    = postgresql_database.tme.name
  role        = "tme"
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT"]
}

resource "postgresql_grant" "tme_schema" {
  database    = postgresql_database.tme.name
  role        = "tme"
  schema      = "public"
  object_type = "schema"
  privileges  = ["CREATE", "USAGE"]
}

resource "postgresql_grant" "tme_tables" {
  database    = postgresql_database.tme.name
  role        = "tme"
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
}
