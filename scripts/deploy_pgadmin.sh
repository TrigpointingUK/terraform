#!/bin/bash

gcloud auth login admin@trigpointing.uk

docker pull dpage/pgadmin4:6
docker tag dpage/pgadmin4:6 europe-west1-docker.pkg.dev/trigpointinguk/images/pgadmin4:6
docker push europe-west1-docker.pkg.dev/trigpointinguk/images/pgadmin4:6

# Below now deployed by terraform
# gcloud run deploy pgadmin \
#   --image=europe-west1-docker.pkg.dev/trigpointinguk/images/pgadmin4:6 \
#   --region=europe-west1 \
#   --service-account=api-tme@trigpointinguk.iam.gserviceaccount.com \
#   --add-cloudsql-instances=trigpointinguk:europe-west1:trigpointing-679c4ef1 \
#   --allow-unauthenticated \
#   --port=80 \
#   --memory=4Gi \
#   --max-instances=1 \
#   --min-instances=0 \
#   --update-env-vars \
# PGADMIN_DEFAULT_EMAIL=teasel.ian@gmail.com,\
# PGADMIN_DISABLE_POSTFIX=true,\
# PGADMIN_LISTEN_ADDRESS=0.0.0.0,\
# PGADMIN_LISTEN_PORT=80,\
# PGADMIN_SERVER_JSON_FILE=/mnt/pgadmin4/servers.json \
#   --update-secrets=PGADMIN_DEFAULT_PASSWORD=TME_POSTGRES_PASSWORD:latest,\
# /mnt/pgadmin4/servers.json=PGADMIN_CONFIG:latest
