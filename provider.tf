#This terraform block has been introduced from 0.13 onwards
terraform {
  #Required Terraform version
  required_version = "~> 1.6" # required_version = 0.14.3
  # Required Providers & other versions
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
  #Remote backend for storing terraform state in S3 Bucket
  #   backend "s3" {
  #     bucket = "value"
  #     key = "value"
  #     region = "value"

  #   }

}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  profile = "default1"

  #static creds  -> not recomended

}

