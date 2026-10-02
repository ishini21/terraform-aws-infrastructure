output "ec2_instance_id" {
  description = "ID of the Terraform project EC2 instance"
  value       = aws_instance.project_ec2.id
}

output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.project_ec2.public_ip
}

output "vpc_id" {
  description = "ID of the project VPC"
  value       = module.networking.vpc_id
}

output "s3_bucket_name" {
  description = "Name of the project S3 bucket"
  value       = module.s3.bucket_name
}