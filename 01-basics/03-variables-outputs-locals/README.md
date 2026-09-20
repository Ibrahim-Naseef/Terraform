# 03 - Variables, outputs and locals

No provider, no cost. `terraform apply` here just prints values, which makes it the fastest way to experiment with Terraform's expression language.

```bash
terraform init && terraform apply -auto-approve
terraform output bucket_names
terraform console   # then try: local.common_tags
```

## The distinction that matters

- **variable** — an input. Something the *caller* of this configuration is allowed to change.
- **local** — a derived value. Computed from variables and other locals; the caller cannot override it.
- **output** — an export. What this configuration hands back to the module that called it, or prints to your terminal.

## Precedence of variable values

Highest wins:

1. `-var` and `-var-file` on the command line
2. `*.auto.tfvars` (alphabetical)
3. `terraform.tfvars`
4. `TF_VAR_name` environment variables
5. The `default` in the `variable` block
