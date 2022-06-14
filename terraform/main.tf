terraform {
  backend "s3" {
    bucket         = "bruvio-tfstate-tf-s3-triggered-lambda-module"
    key            = "tf-s3-triggered-lambda-module.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-setup-tf-state-lock-tf-s3-triggered-lambda-module"
  }
}

provider "aws" {
  region = "us-east-1"
}
locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }


}

data "aws_region" "current" {}
