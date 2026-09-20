terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "my-tf-test-bucket-d1"
    key = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "my-dynamodb-table"
  }
}
