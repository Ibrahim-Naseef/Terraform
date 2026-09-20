provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "terraform-learning"
      ManagedBy = "terraform"
      Workspace = terraform.workspace
    }
  }
}
