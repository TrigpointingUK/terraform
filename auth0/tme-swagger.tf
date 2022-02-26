resource "auth0_client" "tme-swagger" {
  name                       = "tme-swagger"
  description                = "Staging OpenAPI swagger application"
  logo_uri                   = "https://upload.wikimedia.org/wikipedia/commons/a/ab/Swagger-logo.png"
  app_type                   = "regular_web"
  custom_login_page_on       = false
  is_first_party             = true
  token_endpoint_auth_method = "client_secret_post"
  # initiate_login_uri = "http://localhost/login"
  callbacks           = ["https://api.trigpointing.me/docs/oauth2-redirect.html", "http://localhost:3000/docs/oauth2-redirect.html"]
  allowed_logout_urls = []
  web_origins         = []
  allowed_origins     = []
  oidc_conformant     = true
  grant_types         = ["authorization_code", "implicit", "refresh_token", "client_credentials"]
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
    leeway                       = 15
    token_lifetime               = 31557600
    infinite_idle_token_lifetime = false
    infinite_token_lifetime      = false
    idle_token_lifetime          = 2592000
  }
  client_metadata = {
    created_by = "terraform"
  }
  addons {}
  mobile {}
}

output "tme-swagger-client-id" {
  value = auth0_client.tme-swagger.client_id

}