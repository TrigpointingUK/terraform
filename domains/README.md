# terraform

## Domain ownership verification

```bash


curl --request POST \
  'https://www.googleapis.com/siteVerification/v1/token' \
  --header "Authorization: Bearer $(gcloud auth print-access-token --impersonate-service-account=terraform@trigpointinguk.iam.gserviceaccount.com)" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --header 'X-Goog-User-Project: trigpointinguk' \
  --data '{"site":{"type":"INET_DOMAIN","identifier":"trigpointing.me"},"verificationMethod":"DNS_CNAME"}' \
  --compressed

curl --request POST \
  'https://www.googleapis.com/siteVerification/v1/token' \
  --header "Authorization: Bearer $IDTOKEN" \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --header 'X-Goog-User-Project: trigpointinguk' \
  --data '{"site":{"type":"INET_DOMAIN","identifier":"trigpointing.me"},"verificationMethod":"DNS_CNAME"}' \
  --compressed



# Get verification token

curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @request.json \
"https://iam.googleapis.com/v1/projects/trigpointinguk/serviceAccounts/terraform@trigpointinguk.iam.gserviceaccount.com:getIamPolicy"

curl -X POST \
-H "Authorization: Bearer "$(gcloud auth print-access-token --impersonate-service-account=terraform@trigpointinguk.iam.gserviceaccount.com) \
-H "Content-Type: application/json; charset=utf-8" \
-d @get_token.json \
"https://www.googleapis.com/siteVerification/v1/token"


curl -X POST \
-H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
-H "Content-Type: application/json; charset=utf-8" \
-d @get_token.json \
"https://www.googleapis.com/siteVerification/v1/token"

gcloud auth application-default login --scopes=https://www.googleapis.com/auth/siteverification,https://www.googleapis.com/auth/cloud-platform

curl -X POST -H "X-Goog-User-Project: trigpointinguk" -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) -H "Content-Type: application/json; charset=utf-8" -d @get_token.json "https://www.googleapis.com/siteVerification/v1/token"

###

gcloud auth application-default login --scopes=https://www.googleapis.com/auth/siteverification,https://www.googleapis.com/auth/cloud-platform
# authenticate as admin@trigpointing.uk

curl -X POST -H "X-Goog-User-Project: trigpointinguk"  -H "Authorization: Bearer "$(gcloud auth application-default print-access-token --impersonate-service-account=terraform@trigpointinguk.iam.gserviceaccount.com) -H "Content-Type: application/json; charset=utf-8" -d @get_token.json "https://www.googleapis.com/siteVerification/v1/token"

# Paste the results into https://console.cloud.google.com/net-services/dns/zones/trigpointing-me/rrsets/trigpointing.me./TXT/view?project=trigpointinguk



export TOKEN=$(./accesstoken.sh trigpointinguk-terraform-key.json "https://www.googleapis.com/auth/siteverification https://www.googleapis.com/auth/cloud-platform")


curl --request POST   'https://www.googleapis.com/siteVerification/v1/token'   --header "Authorization: Bearer $TOKEN"   --header 'Accept: application/json'   --header 'Content-Type: application/json'   --header 'X-Goog-User-Project: trigpointinguk'   --data '{"site":{"type":"INET_DOMAIN","identifier":"trigpointing.me"},"verificationMethod":"DNS_CNAME"}'   --compressed

# Create a CNAME from the two, space-separated parts, of the token

then try to find out how to insert based on owners.json... except that I then learned how to delegate to a service account using
https://www.google.com/webmasters/verification/details?hl=en&domain=trigpointing.me
```
