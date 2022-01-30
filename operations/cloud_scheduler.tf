resource "google_cloud_scheduler_job" "api-tme" {
  name             = "ping-api-tme"
  description      = "Ping the API health check"
  schedule         = "* * * * *"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "https://api.trigpointing.me/"
  }
}

resource "google_cloud_scheduler_job" "api-tuk" {
  name             = "ping-api-tuk"
  description      = "Ping the API health check"
  schedule         = "* * * * *"
  attempt_deadline = "320s"

  retry_config {
    retry_count = 1
  }

  http_target {
    http_method = "GET"
    uri         = "https://api.trigpointing.uk/"
  }
}

