resource "auth0_email" "mailgun" {
  name                 = "mailgun"
  enabled              = true
  default_from_address = "auth@trigpointing.uk"
  credentials {
    domain  = "trigpointing.uk"
    api_key = file("mailgun_apikey")
    region  = "eu"
  }
}