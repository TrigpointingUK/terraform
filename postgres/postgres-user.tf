########
# GRANTS
########


resource "postgresql_grant" "postgres_db_tme" {
  database    = postgresql_database.tme.name
  role        = "postgres"
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT", "CREATE"]
}

# resource "postgresql_grant" "postgres_schema_tme" {
#   database    = postgresql_database.tme.name
#   role        = "postgres"
#   schema      = "public"
#   object_type = "schema"
#   privileges  = ["CREATE", "USAGE"]
# }

resource "postgresql_grant" "postgres_tables_tme" {
  database    = postgresql_database.tme.name
  role        = "postgres"
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
}



resource "postgresql_grant" "postgres_db_tuk" {
  database    = postgresql_database.tuk.name
  role        = "postgres"
  schema      = "public"
  object_type = "database"
  privileges  = ["CONNECT", "CREATE"]
}

# resource "postgresql_grant" "postgres_schema_tuk" {
#   database    = postgresql_database.tuk.name
#   role        = "postgres"
#   schema      = "public"
#   object_type = "schema"
#   privileges  = ["CREATE", "USAGE"]
# }

resource "postgresql_grant" "postgres_tables_tuk" {
  database    = postgresql_database.tuk.name
  role        = "postgres"
  schema      = "public"
  object_type = "table"
  privileges  = ["SELECT", "INSERT", "UPDATE", "DELETE", "TRUNCATE", "REFERENCES", "TRIGGER"]
}
