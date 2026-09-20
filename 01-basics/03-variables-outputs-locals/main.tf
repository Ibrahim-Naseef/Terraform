# A provider-free playground for Terraform's type system and expressions.
# `terraform init && terraform apply` costs nothing and prints the outputs.

locals {
  # Locals are computed once and reused. Use them for values derived from
  # variables; use variables for values a caller should be able to override.
  name_prefix = "${var.project}-${var.env}"

  common_tags = merge(
    {
      Project     = var.project
      Environment = var.env
      ManagedBy   = "terraform"
    },
    var.extra_tags
  )

  # Conditional expression: the ternary Terraform gives you instead of if/else
  instance_size = var.env == "prod" ? "t3.large" : "t3.micro"

  # for expression over a list
  bucket_names = [for s in var.suffixes : "${local.name_prefix}-${s}"]

  # for expression producing a map, with a filter
  large_envs = { for k, v in var.env_sizes : k => v if v > 1 }
}
