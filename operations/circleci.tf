
# CircleCI account
resource "google_service_account" "circleci" {
  account_id   = "circleci"
  display_name = "CircleCI accoount"
}

# Grant rights to CircleCI account
locals {
  circleci_project_roles = [
    "roles/artifactregistry.repoAdmin",
    "roles/run.developer",
  ]
}
resource "google_project_iam_member" "circleci_project_roles" {
  for_each = toset(local.circleci_project_roles)
  member   = "serviceAccount:${google_service_account.circleci.email}"
  project  = var.project
  role     = each.key
}

resource "google_service_account_iam_member" "circleci-deploy-iam" {
  for_each           = google_service_account.cloudrun
  service_account_id = each.value.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.circleci.email}"
}





# Setup CircleCI project variables

resource "google_service_account_key" "circleci" {
  service_account_id = google_service_account.circleci.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "circleci_environment_variable" "api" {
  provider = circleci

  project = "api"
  name    = "GCLOUD_SERVICE_KEY"
  value   = google_service_account_key.circleci.private_key
}

resource "circleci_environment_variable" "vue" {
  provider = circleci

  project = "vue"
  name    = "GCLOUD_SERVICE_KEY"
  value   = google_service_account_key.circleci.private_key
}


locals {
  gcr         = "${var.region}-docker.pkg.dev"
  api_tag     = "${var.region}-docker.pkg.dev/${var.project}/${google_artifact_registry_repository.images.repository_id}/tuk-api"
  tme_vue_tag = "${var.region}-docker.pkg.dev/${var.project}/${google_artifact_registry_repository.images.repository_id}/tme-vue"
  tuk_vue_tag = "${var.region}-docker.pkg.dev/${var.project}/${google_artifact_registry_repository.images.repository_id}/tuk-vue"
}

### API

resource "circleci_environment_variable" "api_region" {
  provider = circleci

  project = "api"
  name    = "REGION"
  value   = var.region
}

resource "circleci_environment_variable" "api_registry" {
  provider = circleci

  project = "api"
  name    = "GCR"
  value   = local.gcr
}

resource "circleci_environment_variable" "api_tag" {
  provider = circleci

  project = "api"
  name    = "TAG"
  value   = local.api_tag
}

output "api_tag" {
  value = local.api_tag
}

### VUE

resource "circleci_environment_variable" "vue_region" {
  provider = circleci

  project = "vue"
  name    = "REGION"
  value   = var.region
}

resource "circleci_environment_variable" "vue_registry" {
  provider = circleci

  project = "vue"
  name    = "GCR"
  value   = local.gcr
}

resource "circleci_environment_variable" "tme_vue_tag" {
  provider = circleci

  project = "vue"
  name    = "TME_TAG"
  value   = local.tme_vue_tag
}

resource "circleci_environment_variable" "tuk_vue_tag" {
  provider = circleci

  project = "vue"
  name    = "TUK_TAG"
  value   = local.tuk_vue_tag
}

# Obtain clientids from remote auth0 terraform state

data "terraform_remote_state" "auth0" {
  backend = "gcs"

  config = {
    bucket                      = "trigpointinguk-tfstate"
    prefix                      = "trigpointinguk-auth0"
    impersonate_service_account = "terraform@trigpointinguk.iam.gserviceaccount.com"
  }
}

resource "circleci_environment_variable" "tme_vue_auth0" {
  provider = circleci

  project = "vue"
  name    = "TME_AUTH0_CLIENTID"
  value   = data.terraform_remote_state.auth0.outputs.tme-vue-client-id
}

resource "circleci_environment_variable" "tuk_vue_auth0" {
  provider = circleci

  project = "vue"
  name    = "TUK_AUTH0_CLIENTID"
  value   = data.terraform_remote_state.auth0.outputs.tuk-vue-client-id
}


# Ouput all client ids, even those not used by circle-ci

output "tdev-vue-client-id" {
  value = data.terraform_remote_state.auth0.outputs.tdev-vue-client-id
}

output "tme-vue-client-id" {
  value = data.terraform_remote_state.auth0.outputs.tme-vue-client-id
}

output "tme-swagger-client-id" {
  value = data.terraform_remote_state.auth0.outputs.tme-swagger-client-id
}

output "tuk-vue-client-id" {
  value = data.terraform_remote_state.auth0.outputs.tuk-vue-client-id
}
