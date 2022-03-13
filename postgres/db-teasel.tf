resource "postgresql_database" "teasel" {
  provider = postgresql
  name     = "teasel"
}

resource "postgresql_grant" "teasel-tme-db" {
  database    = "teasel"
  role        = "tme"
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT"]
}

resource "postgresql_grant" "teasel-tme-schema" {
  database    = "teasel"
  role        = "tme"
  schema      = "public"
  object_type = "schema"
  privileges  = ["CREATE", "USAGE"]
}

resource "postgresql_grant" "teasel-tme-tables" {
  database    = "teasel"
  role        = "tme"
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
}
