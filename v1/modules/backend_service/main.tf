# Health Check
resource "google_compute_health_check" "this" {
  name = "${var.name}-hc"

  http_health_check {
    port = var.port
    request_path = var.health_check_path
  }
}

# NEG (Network Endpoint Group)
resource "google_compute_network_endpoint_group" "this" {
  name                  = "${var.name}-neg"
  network_endpoint_type = "GCE_VM_IP_PORT"
  network               = var.network
  subnetwork            = var.subnetwork
  default_port          = var.port
  zone                  = var.zone
}

# NEG Endpoints
resource "google_compute_network_endpoint" "this" {
  count                  = length(var.instances)
  network_endpoint_group = google_compute_network_endpoint_group.this.name
  zone                   = var.zone
  instance               = var.instances[count.index].name
  ip_address             = var.instances[count.index].private_ip
  port                   = var.port
}

# Backend Service
resource "google_compute_backend_service" "this" {
  name                  = "${var.name}-backend"
  protocol              = "HTTP"
  port_name             = "http"
  health_checks         = [google_compute_health_check.this.id]
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = var.timeout_sec

  backend {
    group = google_compute_network_endpoint_group.this.id
    balancing_mode = var.balancing_mode
    max_rate_per_endpoint = var.max_rate_per_endpoint
  }

  depends_on = [
    google_compute_network_endpoint.this
  ]
} 