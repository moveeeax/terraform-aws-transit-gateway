terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

variable "region" {
  description = "AWS region for the provider."
  type        = string
  default     = "us-east-1"
}

provider "aws" {
  region = var.region
}

module "transit_gateway" {
  source = "../.."

  description     = "example transit gateway"
  amazon_side_asn = 64512

  tags = {
    Environment = "sandbox"
    ManagedBy   = "terraform"
  }
}

output "transit_gateway_id" {
  value = module.transit_gateway.id
}
