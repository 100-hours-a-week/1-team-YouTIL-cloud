output "vpc_network_name" {
  description = "Name of the created VPC network"
  value       = google_compute_network.vpc_network.name
}

output "bastion_subnet_name" {
  description = "Bastion subnet name"
  value       = google_compute_subnetwork.bastion_subnet.name
}

output "master_subnet_name" {
  description = "Master subnet name"
  value       = google_compute_subnetwork.master_subnet.name
}

output "worker_subnet_name" {
  description = "Worker subnet name"
  value       = google_compute_subnetwork.worker_subnet.name
}

output "monitoring_subnet_name" {
  description = "Monitoring subnet name"
  value       = google_compute_subnetwork.monitoring_subnet.name
}

output "db_subnet_name" {
  description = "DB subnet name"
  value       = google_compute_subnetwork.db_subnet.name
}

output "nat_router_name" {
  description = "NAT router name"
  value       = google_compute_router.nat_router.name
}

output "vpc_network_self_link" {
  description = "Self link of the created VPC network"
  value       = google_compute_network.vpc_network.self_link
}

output "bastion_subnet_self_link" {
  description = "Self link of the bastion subnet"
  value       = google_compute_subnetwork.bastion_subnet.self_link
}

output "master_subnet_self_link" {
  description = "Self link of the master subnet"
  value       = google_compute_subnetwork.master_subnet.self_link
}

output "worker_subnet_self_link" {
  description = "Self link of the worker subnet"
  value       = google_compute_subnetwork.worker_subnet.self_link
}

output "monitoring_subnet_self_link" {
  description = "Self link of the monitoring subnet"
  value       = google_compute_subnetwork.monitoring_subnet.self_link
}

output "db_subnet_self_link" {
  description = "Self link of the db subnet"
  value       = google_compute_subnetwork.db_subnet.self_link
}