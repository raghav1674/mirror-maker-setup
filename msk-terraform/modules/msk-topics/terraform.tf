terraform {
  required_version = ">= 1.5.5"
  required_providers {
    kafka = {
      source  = "Mongey/kafka"
      version = "0.8.3"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.74.0"
    }
  }
}