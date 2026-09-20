# 02 - EC2, key pair and security group

First real AWS resources: an SSH key pair, a security group, and two EC2 instances created with `for_each`.

## Before you run

```bash
../../scripts/generate_keypair.sh terra-key-ec2
export AWS_PROFILE=your-profile
terraform init && terraform plan && terraform apply
```

## What changed from the naive version

| Naive | Here | Why |
|---|---|---|
| `security_groups = [name]` | `vpc_security_group_ids = [id]` | Referencing by name forces instance replacement on any SG change |
| Inline `ingress {}` blocks | `aws_vpc_security_group_ingress_rule` | One rule can change without rewriting all of them |
| `count = 2` | `for_each` over a map | Removing the first instance no longer re-indexes and destroys the second |
| Unencrypted root volume | `encrypted = true` | Encryption at rest, free |
| — | `http_tokens = "required"` | Forces IMDSv2, blocks SSRF credential theft |

## `count` vs `for_each`

`count` addresses resources by position (`aws_instance.this[0]`). Delete the first element of the list and every later instance shifts down an index, so Terraform destroys and recreates them. `for_each` addresses by key (`aws_instance.this["app-2"]`), so keys are stable and unrelated resources are left alone.
