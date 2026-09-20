# State management

## What state actually is

`terraform.tfstate` is a JSON file mapping the resource addresses in your configuration to real object IDs in the cloud:

```
aws_instance.web  ->  i-0abc123def456
```

Terraform needs it to answer "does this already exist, and what did it look like last time?" Delete state and Terraform forgets everything it built — your infrastructure keeps running and billing you, and the next `apply` tries to create duplicates.

## Three problems, three fixes

**1. State on one laptop.** Your teammate cannot apply. Fix: an S3 backend, so state lives somewhere both of you can read.

**2. Two people applying at once.** Both read the same state, both write, the second write erases the first one's resources from state. Fix: a DynamoDB lock table, or `use_lockfile = true` on Terraform 1.10+. Whoever is second gets a clean error instead of silent corruption.

**3. Secrets in plaintext.** An RDS password, a generated key — state stores attribute values verbatim, including sensitive ones. Fix: SSE on the bucket, a public access block, a TLS-only bucket policy, and `.gitignore` so it never reaches a commit.

## Bootstrap order

The backend cannot store its own state in itself. So:

1. `02-state-management/01-backend-bootstrap` — no backend block, local state, creates the bucket and table.
2. Every other stack — declares `backend "s3"`, runs `terraform init`, migrates.

## Backend block

```hcl
terraform {
  backend "s3" {
    bucket         = "cyberz-tf-remote-state"
    key            = "05-eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "cyberz-tf-state-lock"
    encrypt        = true
  }
}
```

Backend blocks cannot use variables or interpolation. To vary them per environment, pass values at init time:

```bash
terraform init -backend-config=backends/prod.hcl
```

## State commands

```bash
terraform state list
terraform state show aws_instance.web
terraform state mv aws_instance.web aws_instance.api    # rename, no recreate
terraform state rm aws_instance.web                     # forget, don't delete
terraform import aws_s3_bucket.legacy my-old-bucket     # adopt existing infra
terraform force-unlock <LOCK_ID>                        # only when certain
terraform state pull > backup.tfstate                   # before anything risky
```

Prefer the declarative equivalents where they exist: `moved` instead of `state mv`, `import {}` instead of `terraform import`, `removed` instead of `state rm`. They live in version control and get reviewed.

## Reading another stack's outputs

```hcl
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "cyberz-tf-remote-state"
    key    = "network/terraform.tfstate"
    region = "ap-south-1"
  }
}

subnet_id = data.terraform_remote_state.network.outputs.private_subnet_ids[0]
```

This is how you split one giant configuration into independently-applied stacks without losing the wiring between them.

## Never

- Edit `terraform.tfstate` by hand.
- Commit it. This repo's `.gitignore` blocks `*.tfstate`, and the old committed copies were removed during the restructure.
- Share one `key` between two stacks.
