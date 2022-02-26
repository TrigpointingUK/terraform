resource "auth0_role" "tme-admin" {
  name = "tme-admin"
  description = "T:ME Administrators (managed by terraform)"

  permissions {
    resource_server_identifier = auth0_resource_server.tme-api.identifier
    name = "create:trigs"
  }

  permissions {
    resource_server_identifier = auth0_resource_server.tme-api.identifier
    name = "create:users"
  }
}