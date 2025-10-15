terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }

  backend "s3" {
    bucket = "tf-state-dartit-ml-project-123"
    key    = "staging/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.aws_region
}
