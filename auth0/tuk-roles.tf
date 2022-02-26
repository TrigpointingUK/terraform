resource "auth0_role" "tuk-admin" {
  name = "tuk-admin"
  description = "T:UK Administrators (managed by terraform)"

  permissions {
    resource_server_identifier = auth0_resource_server.tuk-api.identifier
    name = "create:trigs"
  }

  permissions {
    resource_server_identifier = auth0_resource_server.tuk-api.identifier
    name = "create:users"
  }
}