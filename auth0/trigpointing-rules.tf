resource "auth0_rule" "add-email" {
  name    = "Add email to access token"
  script  = <<EOF

function addEmailToAccessToken(user, context, callback) {
  // This rule adds the authenticated user's email address to the access token.
  var namespace = 'https://trigpointing.uk/';
  context.accessToken[namespace + 'email'] = user.email;
  return callback(null, user, context);
}
EOF
  enabled = true
}
