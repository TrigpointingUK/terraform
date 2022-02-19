module "gcr_cleaner" {
  source  = "mirakl/gcr-cleaner/google"
  version = "1.2.0"

  app_engine_application_location = var.region
  cloud_scheduler_job_schedule = "0 0 * * *"

  gar_repositories = [
    {
      name       = "images/tme-vue"
      region     = var.region
      project_id = var.project
      parameters = {
        grace      = "24h"
        keep       = 1
        tag_filter_all = "^([^t]|t(t|mt)*([^mt]|m[^et]))*(t(t|mt)*m?)?$"
      }
    },
    {
      name       = "images/tuk-vue"
      region     = var.region
      project_id = var.project
      parameters = {
        grace      = "24h"
        keep       = 1
        tag_filter_all = "^([^t]|t(t|ut)*([^tu]|u[^kt]))*(t(t|ut)*u?)?$"
      }
    },
    {
      name       = "images/tuk-api"
      region     = var.region
      project_id = var.project
      parameters = {
        grace      = "24h"
        keep       = 1
        tag_filter_all = "^(.{1,2}|.{4,}|[^t])$"
      }
    }    
  ]
}