terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Backend blocks cannot use variables or interpolation. The values must be
  # literals, or supplied at init time with `-backend-config`.
  backend "s3" {
    bucket = "cyberz-tf-remote-state"
    key    = "02-state-management/app/terraform.tfstate"
    region = "ap-south-1"

    # Classic locking, created by ../01-backend-bootstrap
    dynamodb_table = "cyberz-tf-state-lock"

    # Terraform >= 1.10 alternative: lock with an S3 object and delete the
    # DynamoDB table entirely.
    # use_lockfile = true

    encrypt = true
  }
}
