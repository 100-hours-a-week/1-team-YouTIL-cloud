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