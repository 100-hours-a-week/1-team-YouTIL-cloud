output "vpc_network_name" {
  description = "Name of the created VPC network"
  value       = google_compute_network.vpc_network.name
}

output "bastion_subnet_name" {
  description = "Bastion subnet name"
  value       = google_compute_subnetwork.bastion_subnet.name
}

output "web_subnet_name" {
  description = "Web subnet name"
  value       = google_compute_subnetwork.web_subnet.name
}

output "app_subnet_name" {
  description = "App subnet name"
  value       = google_compute_subnetwork.app_subnet.name
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

output "web_subnet_self_link" {
  description = "Self link of the web subnet"
  value       = google_compute_subnetwork.web_subnet.self_link
}

output "app_subnet_self_link" {
  description = "Self link of the app subnet"
  value       = google_compute_subnetwork.app_subnet.self_link
}

output "db_subnet_self_link" {
  description = "Self link of the db subnet"
  value       = google_compute_subnetwork.db_subnet.self_link
}