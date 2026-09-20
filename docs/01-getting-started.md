# Getting started

## Install

```bash
./scripts/install_terraform.sh
terraform version
```

## Configure AWS credentials

```bash
aws configure --profile terraform-learning
export AWS_PROFILE=terraform-learning
aws sts get-caller-identity
```

Never put an access key in a `.tf` file. The provider picks credentials up from the environment, `~/.aws/credentials`, or an instance/OIDC role.

## The core loop

| Command | Does |
|---|---|
| `terraform init` | Downloads providers and modules, configures the backend. Safe to re-run. |
| `terraform fmt -recursive` | Canonical formatting. Run before every commit. |
| `terraform validate` | Syntax and type checking. No API calls, no credentials needed. |
| `terraform plan` | Shows what would change. Read-only. |
| `terraform apply` | Makes it happen. |
| `terraform destroy` | Tears it down. |

## Habits worth building early

```bash
terraform plan -out=tfplan    # save the plan
terraform apply tfplan        # apply exactly that plan, nothing newer
```

Applying a saved plan removes the window between "I read the plan" and "someone else changed something".

```bash
terraform plan -target=module.vpc   # narrow the blast radius while debugging
```

`-target` is a debugging tool, not a workflow. Using it routinely means your stacks are too big.
