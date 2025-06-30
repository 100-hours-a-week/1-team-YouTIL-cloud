output "instance_id" {
  value       = google_compute_instance.default.id
  description = "The ID of the instance"
}

output "instance_name" {
  value       = google_compute_instance.default.name
  description = "The name of the instance"
}

output "internal_ip" {
  value       = google_compute_instance.default.network_interface[0].network_ip
  description = "Internal IP address"
}

output "public_ip" {
  value       = try(google_compute_instance.default.network_interface[0].access_config[0].nat_ip, null)
  description = "Public IP address (if assigned)"
}

output "instance_self_link" {
  value = google_compute_instance.default.self_link
}