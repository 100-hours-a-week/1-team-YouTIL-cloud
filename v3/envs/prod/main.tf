provider "aws" {
  region = "ap-northeast-2"
  profile = "youtil-prod"
}

locals {
  stage        = "prod"
  project_name = "youtil"
}

module "vpc" {
  stage = local.stage
  project_name = local.project_name
  source = "../../modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  azs = ["ap-northeast-2a", "ap-northeast-2c"]
  tags = {
    Name = "youtil-vpc-prod"
    Env  = "prod"
  }
}

# resource "aws_security_group" "db_sg" {
#   name        = "db-sg-prod"
#   description = "DB access"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port   = 3306 # MySQL
#     to_port     = 3306
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   ingress {
#     from_port   = 6379 # Redis
#     to_port     = 6379
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "db-sg-prod"
#     Env  = "prod"
#   }
# }

# module "db_instance" {
#   source = "../../modules/ec2"
#   ami_id = "ami-01f71f215b23ba262" # Ubuntu 22.04 LTS (2025-07-12)
#   instance_type = "t3.small"
#   subnet_id = module.vpc.db_subnet_ids[0]
#   security_group_ids = [aws_security_group.db_sg.id]
#   key_name = "aws-youtil-prod"
#   associate_public_ip_address = false
#   tags = {
#     Name = "db-prod"
#     Env = "prod"
#     Role = "db"
#   }
#   project_name = local.project_name
#   stage = local.stage
# } 

# resource "aws_security_group" "bastion_sg" {
#   name        = "bastion-sg-prod"
#   description = "OpenVPN Bastion access"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port   = 1194
#     to_port     = 1194
#     protocol    = "udp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 943
#     to_port     = 943
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
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
#     Name = "bastion-sg-prod"
#     Env  = "prod"
#   }
# }

# module "bastion" {
#   source = "../../modules/ec2"
#   ami_id = "ami-0da165fc7156630d7"
#   instance_type = "t3.micro"
#   subnet_id = module.vpc.public_subnet_ids[0]
#   security_group_ids = [aws_security_group.bastion_sg.id]
#   key_name = "aws-youtil-prod"
#   associate_public_ip_address = true
#   tags = {
#     Name = "bastion-prod"
#     Env = "prod"
#     Role = "bastion"
#   }
#   project_name = local.project_name
#   stage = local.stage
# } 