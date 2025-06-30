# URL Map with path-based routing
resource "google_compute_url_map" "this" {
  name            = "${var.name}-urlmap"
  default_service = var.default_backend_service_id

  dynamic "host_rule" {
    for_each = var.host_rules
    content {
      hosts        = [host_rule.value.host]
      path_matcher = host_rule.value.path_matcher
    }
  }

  dynamic "path_matcher" {
    for_each = var.host_rules
    content {
      name            = path_matcher.value.path_matcher
      default_service = path_matcher.value.default_service_id

      dynamic "path_rule" {
        for_each = path_matcher.value.path_rules
        content {
          paths   = path_rule.value.paths
          service = path_rule.value.service_id
        }
      }
    }
  }
}

# Target HTTP Proxy (for redirect)
resource "google_compute_target_http_proxy" "this" {
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.this.id
}

# Target HTTPS Proxy
resource "google_compute_target_https_proxy" "this" {
  name             = "${var.name}-https-proxy"
  url_map          = google_compute_url_map.this.id
  certificate_map = var.certificate_map_id
}

# Global Static IP
resource "google_compute_global_address" "this" {
  name = "${var.name}-ip"
}

# HTTP Forwarding Rule (redirect)
resource "google_compute_global_forwarding_rule" "http" {
  name                  = "${var.name}-http-fr"
  ip_address            = google_compute_global_address.this.address
  port_range            = "80"
  target                = google_compute_target_http_proxy.this.id
  load_balancing_scheme = "EXTERNAL"
}

# HTTPS Forwarding Rule
resource "google_compute_global_forwarding_rule" "https" {
  name                  = "${var.name}-https-fr"
  ip_address            = google_compute_global_address.this.address
  port_range            = "443"
  target                = google_compute_target_https_proxy.this.id
  load_balancing_scheme = "EXTERNAL"
} 