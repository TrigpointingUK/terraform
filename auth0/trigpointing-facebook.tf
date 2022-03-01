resource "auth0_connection" "facebook" {
  name = "Facebook-Connection"
  enabled_clients = [
    auth0_client.tuk-vue.id,
    auth0_client.tme-vue.id,
    auth0_client.tme-swagger.id,
    auth0_client.tdev-vue.id
  ]
  strategy = "facebook"
  options {
    client_id = file("_facebook_clientid")
    client_secret = file("_facebook_clientsecret")
    scopes = [ "public_profile",  "email" ]
    set_user_root_attributes = "on_each_login"
  }
}