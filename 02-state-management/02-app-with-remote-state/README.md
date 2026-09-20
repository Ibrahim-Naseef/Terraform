# 02 - A stack using the remote backend

Run [01-backend-bootstrap](../01-backend-bootstrap) first, then:

```bash
terraform init      # Terraform offers to migrate local state to S3 - say yes
terraform apply
```

Then look in the S3 console: `02-state-management/app/terraform.tfstate` is there, and your local directory has no state file at all.

## State commands worth knowing

```bash
terraform state list                      # every resource Terraform tracks
terraform state show aws_s3_bucket.app    # full attributes of one resource
terraform show -json | jq                 # entire state as JSON

terraform import aws_s3_bucket.app my-existing-bucket   # adopt existing infra
terraform state rm aws_s3_bucket.app                    # forget it, don't delete it
terraform state mv aws_s3_bucket.app aws_s3_bucket.data # rename without recreating

terraform force-unlock <LOCK_ID>          # only after confirming nobody is applying
```

## Rules

1. Never edit `terraform.tfstate` by hand. Use `terraform state` subcommands.
2. Never commit state. It holds resource IDs and often plaintext secrets. This repo's `.gitignore` blocks it.
3. One `key` per stack. Two stacks sharing a key will overwrite each other.
4. `terraform state rm` makes Terraform forget a resource; the real resource keeps running and keeps billing you.
