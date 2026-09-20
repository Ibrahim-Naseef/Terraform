locals {
  # `terraform.workspace` is the name of the currently selected workspace.
  # This map is the single place environment differences are declared.
  env_config = {
    default = {
      instance_count   = 1
      instance_type    = "t3.micro"
      root_volume_size = 10
      versioning       = false
      force_destroy    = true
    }
    dev = {
      instance_count   = 1
      instance_type    = "t3.micro"
      root_volume_size = 10
      versioning       = false
      force_destroy    = true
    }
    stg = {
      instance_count   = 1
      instance_type    = "t3.micro"
      root_volume_size = 15
      versioning       = true
      force_destroy    = true
    }
    prod = {
      instance_count   = 2
      instance_type    = "t3.small"
      root_volume_size = 20
      versioning       = true
      force_destroy    = false
    }
  }

  env = terraform.workspace

  # Fall back to the "default" sizing so an unmapped workspace still
  # evaluates. The precondition in main.tf is what actually blocks the plan.
  cfg = lookup(local.env_config, local.env, local.env_config["default"])

  name = "${var.project}-${local.env}"
}

# Terraform >= 1.5: a check block reports a problem without blocking the plan.
# For a hard failure, see the precondition in main.tf.
check "known_workspace" {
  assert {
    condition     = contains(keys(local.env_config), terraform.workspace)
    error_message = "Workspace '${terraform.workspace}' has no entry in local.env_config."
  }
}
