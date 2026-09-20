provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "terraform-learning"
      ManagedBy = "terraform"
      Stack     = "03-modules/root"
    }
  }
}
