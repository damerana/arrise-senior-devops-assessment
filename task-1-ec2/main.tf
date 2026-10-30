terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
module "ec2_instances" {
  source      = "./modules/ec2_instances"
  instances   = var.instances
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
  }
}
