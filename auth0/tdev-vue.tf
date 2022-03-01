resource "auth0_client" "tdev-vue" {
  name                       = "tdev-vue"
  description                = "Local vue application"
  logo_uri                   = "https://trigpointing.me/TDEV-Logo.svg"
  app_type                   = "spa"
  custom_login_page_on       = false
  is_first_party             = true
  token_endpoint_auth_method = "none"
  # initiate_login_uri = "http://localhost/login"
  callbacks           = ["http://localhost:8080", "http://localhost:8080/auth0"]
  allowed_logout_urls = ["http://localhost:8080", "http://localhost:8080/about"]
  web_origins         = ["http://localhost:8080"]
  allowed_origins     = []
  oidc_conformant     = true
  grant_types         = ["authorization_code", "implicit", "refresh_token"]
  jwt_configuration {
    lifetime_in_seconds = 36000
    secret_encoded      = true
    alg                 = "RS256"
    scopes = {
      # foo = "bar"
    }
  }
  refresh_token {
    rotation_type                = "rotating"
    expiration_type              = "expiring"
    leeway                       = 0
    token_lifetime               = 2592000
    infinite_idle_token_lifetime = false
    infinite_token_lifetime      = false
    idle_token_lifetime          = 1296000
  }
  client_metadata = {
    created_by = "terraform"
  }
  addons {}
  mobile {}
}

output "tdev-vue-client-id" {
  value = auth0_client.tdev-vue.client_id
}