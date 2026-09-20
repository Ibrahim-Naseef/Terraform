terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Deliberately no backend block.
  # This stack CREATES the backend, so it cannot store its state in it.
  # Its own state stays local (or is committed to a separate, private place).
}
