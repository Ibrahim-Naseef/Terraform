# Restructure notes

What changed when this repo went from a flat pile of `.tf` files to topic-ordered stacks.

## File moves

| Before | After |
|---|---|
| `ec2.tf`, `variables.tf`, `outputs.tf`, `providers.tf`, `terraform.tf` (root) | `01-basics/02-ec2-keypair-sg/` |
| `new-file.tf` (commented-out `local_file`) | `01-basics/01-first-resource/main.tf`, uncommented and working |
| `remote-infra/` | `02-state-management/01-backend-bootstrap/` |
| — | `02-state-management/02-app-with-remote-state/` (new: a stack that consumes the backend) |
| `modules/s3/` | `03-modules/modules/s3/` |
| `s3.tf` (module call) | `03-modules/root/main.tf` |
| — | `03-modules/modules/ec2/` (new: the EC2 pattern extracted into a module) |
| `terraform_modules_app/` | `04-workspaces/` (converted from three module calls to one workspace-driven config) |
| `terraform_modules_app/infra-app/` | `04-workspaces/modules/app-infra/` |
| `terraform-eks/` | `05-eks/` |
| `vpc.tf` (root, orphaned) | folded into `05-eks/vpc.tf` |
| `terraform_install.sh` | `scripts/install_terraform.sh` |
| — | `06-examples/`, `docs/`, `assets/`, `Makefile`, CI workflow |

## Correctness and security fixes

1. **`terraform.tfstate` and `terraform.tfstate.backup` removed from Git.** The 83 KB backup contained full resource IDs and attribute values. `.gitignore` listed `*.tfstate`, but the files had been committed before the rule existed, so Git kept tracking them. See "Purging state from history" below.
2. **`terraform-eks/terraform.tf` was empty.** No `required_providers`, no `required_version` — the AWS provider version was whatever `init` happened to resolve. Now pinned.
3. **Unpinned registry modules.** `terraform-aws-modules/vpc/aws` had no `version`. Added `~> 5.13`.
4. **`security_groups = [name]` → `vpc_security_group_ids = [id]`.** Referencing an EC2 security group by name forces instance replacement whenever the SG changes.
5. **Inline `ingress` blocks → `aws_vpc_security_group_ingress_rule`.** Inline blocks rewrite every rule on any change.
6. **`count` → `for_each`** where the collection can shrink, so removing one instance stops re-indexing and recreating its siblings.
7. **`var.env == "prod"? 20: 15`** — malformed spacing around the ternary, now `terraform fmt` clean.
8. **Root volumes encrypted**, IMDSv2 required (`http_tokens = "required"`).
9. **`prevent_destroy` on the state bucket and lock table.** These are the two resources whose loss is unrecoverable.
10. **TLS-only bucket policy, versioning, PITR** on state storage.
11. **`file("terra-key-ec2.pub")` with no key present.** Added `scripts/generate_keypair.sh` and a `public_key_path` variable; private keys are gitignored.
12. **`aws_default_vpc` duplicated** across three stacks — unavoidable given each is independent, but now documented as a learning shortcut rather than a pattern to copy.

## Purging state from history

Deleting the files in a new commit stops future leakage but leaves them readable in every earlier commit. To remove them properly:

```bash
pip install git-filter-repo

git filter-repo --invert-paths \
  --path terraform.tfstate \
  --path terraform.tfstate.backup

git push --force-with-lease origin main
```

This rewrites history. Anyone else with a clone must re-clone. Since this repo has 5 commits and no forks, now is the cheapest possible moment to do it.

If the old state referenced real account IDs or any credential, rotate those regardless — assume anything pushed to a public repo has been scraped.
