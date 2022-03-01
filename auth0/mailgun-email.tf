resource "auth0_email" "mailgun" {
  name                 = "mailgun"
  enabled              = true
  default_from_address = "auth@mg.trigpointing.uk"
  credentials {
    domain  = "mg.trigpointing.uk"
    api_key = file("_mailgun_apikey")
    region  = "eu"
  }
}