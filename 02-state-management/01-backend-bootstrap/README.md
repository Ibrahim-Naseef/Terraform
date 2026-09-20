# 01 - Bootstrap the remote backend

Creates the two resources every other stack depends on: an S3 bucket for state and a DynamoDB table for locking.

This is the one chicken-and-egg stack in the repo. It cannot store its own state in the backend it is creating, so it keeps state locally. Run it once, then never think about it again.

```bash
terraform init
terraform apply
terraform output backend_snippet
```

## Why both a bucket and a table

| Problem | Solved by |
|---|---|
| State on one laptop only; teammate can't apply | S3 bucket (shared, durable) |
| Two people apply simultaneously and clobber each other | DynamoDB lock (or S3 `use_lockfile`) |
| Bad apply corrupted state | S3 versioning |
| State contains plaintext secrets | SSE + public access block + TLS-only policy |

`prevent_destroy = true` on both resources means `terraform destroy` will refuse to run. That is intentional.
