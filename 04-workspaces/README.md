# 04 - Workspaces (dev / stg / prod)

One configuration directory. One set of `.tf` files. Three completely separate state files.

```bash
terraform init

terraform workspace new dev
terraform workspace new stg
terraform workspace new prod

terraform workspace list      # * marks the current one
terraform workspace show

terraform workspace select dev
terraform plan                # t3.micro, 1 node, versioning off

terraform workspace select prod
terraform plan                # t3.small, 2 nodes, versioning on, PITR on
```

Nothing in the `.tf` files changed between those two plans. The only difference is `terraform.workspace`.

## How it works

`locals.tf` holds a map keyed by workspace name:

```hcl
env_config = {
  dev  = { instance_count = 1, instance_type = "t3.micro", ... }
  stg  = { instance_count = 1, instance_type = "t3.micro", ... }
  prod = { instance_count = 2, instance_type = "t3.small", ... }
}

cfg = lookup(local.env_config, terraform.workspace, local.env_config["default"])
```

Every environment difference lives in that one map. Adding a `qa` environment is four lines, not a new folder.

## Where the state goes

| Backend | dev state lands at |
|---|---|
| local | `terraform.tfstate.d/dev/terraform.tfstate` |
| S3 | `s3://<bucket>/env:/dev/04-workspaces/terraform.tfstate` |

The `default` workspace is special: it does **not** get the `env:/` prefix. That is why this repo names its real environments `dev`, `stg` and `prod` and leaves `default` unused.

## The guard rail

An unmapped workspace name is the classic workspace footgun — you type `terraform workspace new produciton`, Terraform happily creates it, and you apply dev-sized infrastructure thinking it is production. Two things prevent that here:

- a `check` block that reports the problem during plan
- a `precondition` on `terraform_data.workspace_guard` that **fails** the plan outright

## Workspaces vs separate directories

| | Workspaces | Directory per environment |
|---|---|---|
| Code duplication | none | three copies to keep in sync |
| Adding an env | `terraform workspace new qa` | copy a folder |
| Blast radius of a bad edit | all three environments | one |
| Different backends/accounts per env | not possible | easy |
| Different resource *shapes* per env | awkward | natural |

**Rule of thumb:** workspaces for environments that differ only in *size*. Separate root directories (or Terragrunt) when environments differ in *structure*, live in different AWS accounts, or need different backends.

## Common mistakes

1. Forgetting to run `terraform workspace select` and applying to the wrong environment. Put the workspace in your shell prompt.
2. Leaving resources without `terraform.workspace` in their name — two workspaces then fight over the same globally-unique S3 bucket name and the second `apply` fails.
3. Using the `default` workspace as production.
