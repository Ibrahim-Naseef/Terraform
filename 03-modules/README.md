# 03 - Modules

```
03-modules/
├── modules/
│   ├── s3/          reusable, documented, no provider block
│   └── ec2/         reusable, documented, no provider block
└── root/            the caller: wires modules together, owns the provider
```

## Run it

```bash
cd root
../../scripts/generate_keypair.sh terra-key-ec2
terraform init && terraform plan
```

## Anatomy of a good module

| File | Holds |
|---|---|
| `variables.tf` | every input, each with `description`, `type`, and `validation` where it helps |
| `main.tf` | the resources |
| `outputs.tf` | everything a caller might need downstream |
| `versions.tf` | `required_version` + permissive provider constraints |
| `README.md` | usage example, inputs table, outputs table |

## Rules learned the hard way

1. **No `provider` blocks inside a module.** Modules inherit providers. A hardcoded provider block makes the module unusable in multi-region setups.
2. **Pin versions in the root, constrain loosely in the module.** `~> 6.0` in the root; `>= 5.0` in the module.
3. **Output more than you think you need.** Adding an output later is free; a caller blocked by a missing output has to fork your module.
4. **Validate inputs at the boundary.** A `validation` block fails in milliseconds during `plan`; an invalid bucket name fails two minutes into `apply`.
5. **Don't nest deeply.** Root → module is fine. Root → module → module → module is a debugging nightmare.

## Module sources

```hcl
source = "./modules/s3"                              # local path
source = "terraform-aws-modules/vpc/aws"             # registry
source = "git::https://github.com/org/repo.git//s3?ref=v1.2.0"  # git, pinned tag
```

Always pin a `ref` or `version` on remote sources. An unpinned module can change under you between two applies.
