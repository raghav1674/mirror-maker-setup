terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.70.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.3.5"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = var.default_tags
  }
}