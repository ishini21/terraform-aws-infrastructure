output "vpc_id" {
  description = "ID of the project VPC"
  value       = aws_vpc.this.id
}
output "subnet_id" {
  description = "ID of the project subnet"
  value       = aws_subnet.this.id
}
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}
output "route_table_id"{
    description = "ID of roter table"
    value = aws_route_table.this.id
}
output "security_group_id"{
    description = "ID of security groups"
    value = aws_security_group.this.id
}