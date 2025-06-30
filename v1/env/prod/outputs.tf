output "vpc_network_name" {
  description = "생성된 VPC 네트워크 이름"
  value       = module.vpc.vpc_network_name
}

output "bastion_subnet_name" {
  description = "Bastion 서브넷 이름"
  value       = module.vpc.bastion_subnet_name
}

output "web_subnet_name" {
  description = "Web Tier 서브넷 이름"
  value       = module.vpc.web_subnet_name
}

output "app_subnet_name" {
  description = "App (BE) Tier 서브넷 이름"
  value       = module.vpc.app_subnet_name
}

output "db_subnet_name" {
  description = "DB Tier 서브넷 이름"
  value       = module.vpc.db_subnet_name
}