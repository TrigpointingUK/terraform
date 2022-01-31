locals {
  cloudrun_services = [
    "api-tme",
    "api-tuk",
    "vue-tme",
    "vue-tuk",
  ]
}

# Service accounts
resource "google_service_account" "cloudrun" {
  for_each     = toset(local.cloudrun_services)
  account_id   = each.key
  display_name = "Cloud Run service accoount"
}


# Allow access to secrets
resource "google_project_iam_member" "cloudrun_secret_iam" {
  for_each = google_service_account.cloudrun
  member   = "serviceAccount:${each.value.email}"
  role     = "roles/secretmanager.secretAccessor"
  project  = var.project
}


# Allow public access to endpoints
resource "google_cloud_run_service_iam_member" "default" {
  for_each = toset(local.cloudrun_services)
  location = var.region
  project  = var.project
  service  = each.key
  role     = "roles/run.invoker"
  member   = "allUsers"
}


# Map api.trigpointing.me domain
data "google_cloud_run_service" "api-tme" {
  name = "api-tme"
  location = var.region
}

resource "google_cloud_run_domain_mapping" "api-tme" {
  location = var.region
  name     = "api.trigpointing.me"
  metadata {
    namespace = var.project
  }
  spec {
    route_name = data.google_cloud_run_service.api-tme.name
  }
}

resource "google_dns_record_set" "api-tme" {
  name = "api.${google_dns_managed_zone.tme-zone.dns_name}"
  type = "CNAME"
  ttl  = 300
  managed_zone = google_dns_managed_zone.tme-zone.name
  rrdatas = [google_cloud_run_domain_mapping.api-tme.status[0].resource_records[0].rrdata]
}

output "api_trigpointing_me_cname" {
    value = google_cloud_run_domain_mapping.api-tme.status[0].resource_records[0].rrdata
}



# Map api.trigpointing.uk domain
data "google_cloud_run_service" "api-tuk" {
  name = "api-tuk"
  location = var.region
}

resource "google_cloud_run_domain_mapping" "api-tuk" {
  location = var.region
  name     = "api.trigpointing.uk"
  metadata {
    namespace = var.project
  }
  spec {
    route_name = data.google_cloud_run_service.api-tuk.name
  }
}

### NB DNS nameservers still at 123-reg, so this needs to be applied manually there
# resource "google_dns_record_set" "api-tuk" {
#   name = "api.${google_dns_managed_zone.tuk-zone.dns_name}"
#   type = "CNAME"
#   ttl  = 300
#   managed_zone = google_dns_managed_zone.tuk-zone.name
#   rrdatas = [google_cloud_run_domain_mapping.api-tuk.status[0].resource_records[0].rrdata]
# }

# output "api_trigpointing_uk_cname" {
#     value = google_cloud_run_domain_mapping.api-tuk.status[0].resource_records[0].rrdata
# }



# Map trigpointing.me domain
data "google_cloud_run_service" "vue-tme" {
  name = "vue-tme"
  location = var.region
}

resource "google_cloud_run_domain_mapping" "vue-tme" {
  location = var.region
  name     = "trigpointing.me"
  metadata {
    namespace = var.project
  }
  spec {
    route_name = data.google_cloud_run_service.vue-tme.name
  }
}

resource "google_dns_record_set" "vue-tme" {
  name = "${google_dns_managed_zone.tme-zone.dns_name}"
  type = "A"
  ttl  = 300
  managed_zone = google_dns_managed_zone.tme-zone.name
  rrdatas = [ for ip in google_cloud_run_domain_mapping.vue-tme.status[0].resource_records[*].rrdata : ip if length(regexall(":", ip)) == 0 ]
}

output "vue_trigpointing_me_rrdata" {
    value = google_dns_record_set.vue-tme.rrdatas
}



# Map vue.trigpointing.uk domain
data "google_cloud_run_service" "vue-tuk" {
  name = "vue-tuk"
  location = var.region
}

resource "google_cloud_run_domain_mapping" "vue-tuk" {
  location = var.region
  name     = "vue.trigpointing.uk"
  metadata {
    namespace = var.project
  }
  spec {
    route_name = data.google_cloud_run_service.vue-tuk.name
  }
}

### NB DNS nameservers still at 123-reg, so this needs to be applied manually there
# resource "google_dns_record_set" "vue-tuk" {
#   name = "vue.${google_dns_managed_zone.tuk-zone.dns_name}"
#   type = "CNAME"
#   ttl  = 300
#   managed_zone = google_dns_managed_zone.tuk-zone.name
#   rrdatas = [google_cloud_run_domain_mapping.vue-tuk.status[0].resource_records[0].rrdata]
# }

# output "vue_trigpointing_uk_cname" {
#     value = google_cloud_run_domain_mapping.vue-tuk.status[0].resource_records[0].rrdata
# }