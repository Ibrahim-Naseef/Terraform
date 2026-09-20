# Workspaces

```bash
terraform workspace list      # show all, * marks current
terraform workspace new dev
terraform workspace select prod
terraform workspace show
terraform workspace delete qa # must be empty first
```

## What they actually do

A workspace is a named, separate state file for the same configuration. Nothing else changes — same `.tf` files, same providers, same resources.

| Backend | Where `dev` state lands |
|---|---|
| local | `terraform.tfstate.d/dev/terraform.tfstate` |
| S3 | `s3://bucket/env:/dev/<key>` |

`default` is special: no `env:/` prefix. Leave it unused and name your real environments explicitly.

## Driving differences off the workspace

```hcl
locals {
  env_config = {
    dev  = { instance_type = "t3.micro", instance_count = 1 }
    stg  = { instance_type = "t3.micro", instance_count = 1 }
    prod = { instance_type = "t3.small", instance_count = 2 }
  }

  cfg = lookup(local.env_config, terraform.workspace, local.env_config["default"])
}

resource "aws_instance" "app" {
  count         = local.cfg.instance_count
  instance_type = local.cfg.instance_type
  tags          = { Name = "app-${terraform.workspace}" }
}
```

Every environment difference is in one map. Adding `qa` is four lines.

## Workspaces vs directory-per-environment

| | Workspaces | Directory per env |
|---|---|---|
| Duplication | none | 3 copies |
| New environment | one command | copy a folder |
| Blast radius of a typo | all environments | one |
| Different AWS accounts per env | no | yes |
| Different backends per env | no | yes |
| Structurally different envs | awkward | natural |

**Use workspaces** when environments differ only in size and live in one account.
**Use separate root directories** when they differ in structure, span accounts, or need different backends. Most real organisations end up here, often with Terragrunt on top.

## Footguns

1. Applying to the wrong workspace because you forgot to `select`. Put `terraform workspace show` in your shell prompt.
2. Globally-unique names without `terraform.workspace` in them. Two workspaces then collide on the same S3 bucket name.
3. Treating `default` as production.
4. A typo'd workspace name (`produciton`) silently creating a new environment. Guard with a `precondition` — see `04-workspaces/main.tf`.
