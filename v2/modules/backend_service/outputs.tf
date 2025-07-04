output "backend_service_id" {
  description = "생성된 백엔드 서비스의 ID"
  value       = google_compute_backend_service.this.id
}

output "neg_id" {
  description = "생성된 NEG의 ID"
  value       = google_compute_network_endpoint_group.this.id
}

output "health_check_id" {
  description = "생성된 헬스 체크의 ID"
  value       = google_compute_health_check.this.id
} 