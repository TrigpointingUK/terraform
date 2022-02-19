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
        keep       = 5
        tag_filter_any = ".*"
      }
    },
    {
      name       = "images/tuk-vue"
      region     = var.region
      project_id = var.project
      parameters = {
        grace      = "24h"
        keep       = 5
        tag_filter_any = ".*"
      }
    },
    {
      name       = "images/tuk-api"
      region     = var.region
      project_id = var.project
      parameters = {
        grace      = "24h"
        keep       = 5
        tag_filter_any = ".*"
      }
    }    
  ]
}