# One configuration. One set of files. Three isolated state files, selected
# by `terraform workspace select`.

module "infra" {
  source = "./modules/app-infra"

  name              = local.name
  env               = local.env
  ami_id            = var.ami_id
  hash_key          = var.hash_key
  instance_count    = local.cfg.instance_count
  instance_type     = local.cfg.instance_type
  root_volume_size  = local.cfg.root_volume_size
  enable_versioning = local.cfg.versioning
  force_destroy     = local.cfg.force_destroy
  public_key_path   = "${path.root}/terra-key-ec2.pub"
}

# A hard guard: refuse to plan at all in an unmapped workspace.
resource "terraform_data" "workspace_guard" {
  input = terraform.workspace

  lifecycle {
    precondition {
      condition     = contains(keys(local.env_config), terraform.workspace)
      error_message = "Unknown workspace '${terraform.workspace}'. Add it to local.env_config in locals.tf first."
    }
  }
}
