variable "vpc_cidr" {
  description = "CIDR block for the project VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the project subnet"
  type        = string
}
variable "environment" {
  description = "Environment name"
  type        = string
}