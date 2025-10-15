provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket        = "tf-state-dartit-ml-project-123"
  force_destroy = true # for test only

  tags = {
    Name = "Terraform State Bucket"
  }
}