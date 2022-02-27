resource "auth0_client" "tuk-vue" {
  name                       = "tuk-vue"
  description                = "Live vue application"
  logo_uri                   = "https://trigpointing.me/TUK-Logo.svg"
  app_type                   = "spa"
  custom_login_page_on       = false
  is_first_party             = true
  token_endpoint_auth_method = "none"
  # initiate_login_uri = "http://localhost/login"
  callbacks           = ["https://vue.trigpointing.uk/", "https://vue.trigpointing.uk/auth0", "https://api.trigpointing.uk/docs/oauth2-redirect"]
  allowed_logout_urls = ["https://vue.trigpointing.uk/", "https://vue.trigpointing.uk/about"]
  web_origins         = ["https://vue.trigpointing.uk/"]
  allowed_origins     = []
  oidc_conformant     = true
  grant_types         = ["authorization_code", "implicit", "refresh_token"]
  jwt_configuration {
    lifetime_in_seconds = 60
    secret_encoded      = true
    alg                 = "RS256"
    scopes = {
      # foo = "bar"
    }
  }
  refresh_token {
    rotation_type                = "rotating"
    expiration_type              = "expiring"
    leeway                       = 15
    token_lifetime               = 600
    infinite_idle_token_lifetime = false
    infinite_token_lifetime      = false
    idle_token_lifetime          = 300
  }
  client_metadata = {
    created_by = "terraform"
  }
  addons {}
  mobile {}
}

output "tuk-vue-client-id" {
  value = auth0_client.tuk-vue.client_id
}