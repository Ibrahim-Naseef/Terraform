terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.32"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.15"
    }
  }

  # Recommended once ../02-state-management/01-backend-bootstrap has run.
  # An EKS cluster is far too important to track in a local state file.
  #
  # backend "s3" {
  #   bucket         = "cyberz-tf-remote-state"
  #   key            = "05-eks/terraform.tfstate"
  #   region         = "ap-south-1"
  #   dynamodb_table = "cyberz-tf-state-lock"
  #   encrypt        = true
  # }
}
