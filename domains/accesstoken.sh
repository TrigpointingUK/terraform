#!/bin/bash

set -euo pipefail

key_json_file="$1"
scope="$2"

jwt_token=$(./jwttoken.sh "$key_json_file" "$scope")

curl -s -X POST https://www.googleapis.com/oauth2/v4/token \
    --data-urlencode 'grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer' \
    --data-urlencode "assertion=$jwt_token" \
    | jq -r .access_token
