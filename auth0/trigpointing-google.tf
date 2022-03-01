resource "auth0_connection" "google" {
  name = "Google-Connection"
  enabled_clients = [
    auth0_client.tuk-vue.id,
    auth0_client.tme-vue.id,
    auth0_client.tme-swagger.id,
    auth0_client.tdev-vue.id
  ]
  strategy = "google-oauth2"
  options {
    client_id = file("_google_clientid")
    client_secret = file("_google_clientsecret")
    scopes = [ "profile",  "email" ]
    set_user_root_attributes = "on_each_login"
    # allowed_audiences = [ "example.com", "api.example.com" ]
  }
}