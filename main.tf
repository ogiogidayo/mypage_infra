# -----------------------
# Terraform configuration
# -----------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "mypage-tfstate-bucket-ogiwara"
    key    = "mypage-dev.tfstate"
    region = "ap-northeast-1"
  }
}

# -----------------------
# Provider
# -----------------------
provider "aws" {
  region = "ap-northeast-1"
}

# -----------------------
# Variables
# -----------------------
variable "project" {
  type = string
}

variable "environment" {
  type = string
}