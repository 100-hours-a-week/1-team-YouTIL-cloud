# Certificate Map
resource "google_certificate_manager_certificate_map" "this" {
  name     = "${var.name}-cert-map"
}

# Certificate Map Entries for each domain
resource "google_certificate_manager_certificate_map_entry" "this" {
  for_each = toset(var.domain_names)
  name     = "${var.name}-cert-map-entry-${replace(each.value, ".", "-")}"
  map      = google_certificate_manager_certificate_map.this.name
  certificates = [var.ssl_certificate_ids[each.value]]
  hostname     = each.value
} 