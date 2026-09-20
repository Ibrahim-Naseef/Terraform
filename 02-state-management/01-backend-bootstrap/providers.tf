provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Purpose   = "terraform-remote-state"
      ManagedBy = "terraform"
    }
  }
}
