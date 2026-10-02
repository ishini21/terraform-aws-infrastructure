# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region
# }
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-project-2-state-ishini"
    key          = "terraform.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}

module "networking" {
  source = "./modules/networking"

  vpc_cidr    = var.vpc_cidr
  subnet_cidr = var.subnet_cidr
  environment = var.environment
}
# module "s3" {
#   source = "./modules/s3"

#   bucket_name = "first-terraform-project-2"
#   environment = "Dev"
# }
module "s3" {
  source = "./modules/s3"

  bucket_name = var.s3_bucket_name
  environment = var.environment
}
# resource "aws_subnet" "project_subnet" {
#   vpc_id     = module.networking.vpc_id
#   cidr_block = var.subnet_cidr

#   tags = {
#     Name        = "terraform-project-public-subnet"
#     Environment = "Dev"
#   }
# }


# resource "aws_internet_gateway" "project_igw" {
#   vpc_id = module.networking.vpc_id

#   tags = {
#     Name        = "terraform-project-igw"
#     Environment = "Dev"
#   }
# }

# resource "aws_route_table" "project_route_table" {
#   vpc_id = module.networking.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = module.networking.internet_gateway_id
#   }

#   tags = {
#     Name        = "terraform-project-public-route-table"
#     Environment = "Dev"
#   }
# }

# resource "aws_route_table_association" "project_subnet_association" {
#   subnet_id      = module.networking.subnet_id
#   route_table_id = module.networking.route_table_id
# }

# resource "aws_security_group" "project_sg" {
#   name        = "terraform-project-sg"
#   description = "Security group for Terraform project EC2"
#   vpc_id      = module.networking.vpc_id

#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name        = "terraform-project-sg"
#     Environment = "Dev"
#   }
# }

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "project_ec2" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  key_name = aws_key_pair.project_key.key_name

  subnet_id                   = module.networking.subnet_id
  vpc_security_group_ids      = [module.networking.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "terraform-project-ec2"
    # Environment = "Dev"
    Environment = var.environment
  }
}

resource "aws_key_pair" "project_key" {
  key_name   = "terraform-project-key"
  public_key = file(pathexpand("~/.ssh/terraform-project-ec2.pub"))

  tags = {
    Name = "terraform-project-key"
    # Environment = "Dev"
    Environment = var.environment
  }
}