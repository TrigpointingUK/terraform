resource "google_dns_managed_zone" "tme-zone" {
  name        = "trigpointing-me"
  dns_name    = "trigpointing.me."
  description = "TrigpointingUK Test zone"
}

resource "google_dns_managed_zone" "tuk-zone" {
  name        = "trigpointing-uk"
  dns_name    = "trigpointing.uk."
  description = "TrigpointingUK Live zone"
}

output "tuk-nameservers" {
  value = google_dns_managed_zone.tuk-zone.name_servers
}

output "tme-nameservers" {
  value = google_dns_managed_zone.tme-zone.name_servers
}
