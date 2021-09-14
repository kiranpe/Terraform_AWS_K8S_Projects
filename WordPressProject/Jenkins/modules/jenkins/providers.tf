#Terraform configuration
terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      version = ">=2.0"
      source  = "hashicorp/aws"
    }
  }
}

#Aws Configuration

provider "aws" {
  region  = "us-east-2"
  profile = "DevOps"
}
