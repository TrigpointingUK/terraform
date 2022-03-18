data "terraform_remote_state" "operations" {
  backend = "gcs"

  config = {
    bucket                      = "trigpointinguk-tfstate"
    prefix                      = "trigpointinguk-operations"
    impersonate_service_account = "terraform@trigpointinguk.iam.gserviceaccount.com"
  }
}
