# 06 - Feature examples

Provider-free (just `hashicorp/local`), so everything here runs in seconds and costs nothing.

```bash
terraform init && terraform apply -auto-approve
ls out/
```

| File | Feature | Why it matters |
|---|---|---|
| `01-count-vs-for_each.tf` | `count`, `for_each` | The single most common cause of accidental resource recreation |
| `02-lifecycle.tf` | `create_before_destroy`, `ignore_changes`, `prevent_destroy`, `precondition`, `postcondition` | Zero-downtime replacement and plan-time guard rails |
| `03-moved-and-removed.tf` | `moved`, `removed` | Refactor resource names without destroying infrastructure |
| `04-validation-and-check.tf` | `validation`, `check` | Fail fast on bad inputs; warn on suspicious ones |
| `terraform-test/` | `terraform test` | Assert on plans and applies in CI |

## The `import` block

Terraform 1.5+ can adopt existing infrastructure declaratively instead of via the `terraform import` CLI:

```hcl
import {
  to = aws_s3_bucket.legacy
  id = "my-manually-created-bucket"
}

resource "aws_s3_bucket" "legacy" {
  bucket = "my-manually-created-bucket"
}
```

Then `terraform plan -generate-config-out=generated.tf` will write the resource block for you. Review it before committing — generated config is a starting point, not a finished file.
