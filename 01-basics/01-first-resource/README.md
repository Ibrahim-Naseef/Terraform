# 01 - Your first resource

No AWS credentials required. This exists purely to make the core workflow muscle memory.

```bash
terraform init      # download the local provider
terraform plan      # see what WOULD happen
terraform apply      # make it happen
cat automate.txt
terraform destroy    # clean up
```

**What to notice**

- `terraform init` creates `.terraform/` and `.terraform.lock.hcl`. The lock file *is* committed; `.terraform/` is not.
- `terraform plan` is read-only. Run it as often as you like.
- After `apply`, a `terraform.tfstate` appears. That file is Terraform's memory of what it built — and the reason [02-state-management](../../02-state-management) exists.
