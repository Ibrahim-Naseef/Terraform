provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "terraform-learning"
      ManagedBy = "terraform"
      Stack     = "01-basics/02-ec2-keypair-sg"
    }
  }
}
