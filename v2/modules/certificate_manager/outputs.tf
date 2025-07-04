output "certificate_map_id" {
  description = "Certificate Map의 전체 리소스 경로"
  value       = "//certificatemanager.googleapis.com/projects/${var.project}/locations/global/certificateMaps/${google_certificate_manager_certificate_map.this.name}"
} 