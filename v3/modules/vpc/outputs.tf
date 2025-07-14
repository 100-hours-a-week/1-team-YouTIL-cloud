output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db_subnets[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw[0].id
}

output "nat_eip_address" {
  value = aws_eip.nat_eip[0].public_ip
}

output "private_route_table_id" {
  value = aws_route_table.private_rt[0].id
}