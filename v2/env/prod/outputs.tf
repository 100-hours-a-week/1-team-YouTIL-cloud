output "vpc_network_name" {
  description = "생성된 VPC 네트워크 이름"
  value       = module.vpc.vpc_network_name
}

output "bastion_subnet_name" {
  description = "Bastion 서브넷 이름"
  value       = module.vpc.bastion_subnet_name
}

output "master_subnet_name" {
  description = "Master 서브넷 이름"
  value       = module.vpc.master_subnet_name
}

output "worker_subnet_name" {
  description = "Worker 서브넷 이름"
  value       = module.vpc.worker_subnet_name
}

output "monitoring_subnet_name" {
  description = "Monitoring 서브넷 이름"
  value       = module.vpc.monitoring_subnet_name
}

output "db_subnet_name" {
  description = "DB 서브넷 이름"
  value       = module.vpc.db_subnet_name
}