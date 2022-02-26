resource "auth0_connection" "tme-users" {
  name     = "tme-users"
  enabled_clients = [ 
    auth0_client.tme-vue.id,
    auth0_client.tme-swagger.id,
    auth0_client.tdev-vue.id
  ]
  strategy = "auth0"
  options {
    requires_username = "false"
    password_policy   = "fair"
    password_history {
      enable = true
      size   = 3
    }
    password_dictionary {
      enable = true
    }
    password_complexity_options {
      min_length = 8
    }
    mfa {
      active = false
    }
    brute_force_protection         = true
    enabled_database_customization = false
    set_user_root_attributes       = "on_each_login"
  }
}