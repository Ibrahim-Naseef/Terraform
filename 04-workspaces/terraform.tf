terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # With an S3 backend, each workspace gets its own key automatically:
  #   env:/dev/04-workspaces/terraform.tfstate
  #   env:/stg/04-workspaces/terraform.tfstate
  # The "default" workspace is the only one without the env:/ prefix.
  #
  # backend "s3" {
  #   bucket         = "cyberz-tf-remote-state"
  #   key            = "04-workspaces/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "cyberz-tf-state-lock"
  #   encrypt        = true
  # }
}
