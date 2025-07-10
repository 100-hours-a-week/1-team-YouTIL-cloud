output "vpc_network_name" {
  description = "생성된 VPC 네트워크 이름"
  value       = module.vpc.vpc_network_name
}

output "bastion_subnet_name" {
  description = "Bastion 서브넷 이름"
  value       = module.vpc.bastion_subnet_name
}

output "node_subnet_name" {
  description = "Node 서브넷 이름"
  value       = module.vpc.node_subnet_name
}

output "db_subnet_name" {
  description = "DB 서브넷 이름"
  value       = module.vpc.db_subnet_name
}