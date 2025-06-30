output "ip_address" {
  description = "로드밸런서의 IP 주소"
  value       = google_compute_global_address.this.address
}

output "url_map_id" {
  description = "URL Map의 ID"
  value       = google_compute_url_map.this.id
}

output "http_proxy_id" {
  description = "HTTP 프록시의 ID"
  value       = google_compute_target_http_proxy.this.id
}

output "https_proxy_id" {
  description = "HTTPS 프록시의 ID"
  value       = google_compute_target_https_proxy.this.id
} 