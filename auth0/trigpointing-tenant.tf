resource "auth0_tenant" "tenant" {

  friendly_name = "TrigpointingUK"
  picture_url   = "https://trigpointing.me/TUK-Logo.svg"
  support_email = "teasel.ian@gmail.com"
  support_url   = "https://trigpointing.uk"

  session_lifetime = 720
  sandbox_version  = "12"
  enabled_locales  = ["en"]

}
