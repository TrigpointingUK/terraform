resource "auth0_resource_server" "tme-api" {
  name        = "tme-api"
  identifier  = "https://api.trigpointing.me"
  signing_alg = "RS256"

  scopes {
    value       = "openid profile email"
    description = "Email access"
  }

  scopes {
    value       = "create:trigs"
    description = "Create trigpoint records"
  }

  scopes {
    value       = "create:users"
    description = "Create user record without OAuth"
  }

  allow_offline_access                            = false
  token_lifetime                                  = 86400
  token_lifetime_for_web                          = 7200
  skip_consent_for_verifiable_first_party_clients = true
  enforce_policies                                = true
  token_dialect                                   = "access_token_authz"
}
