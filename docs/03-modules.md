# Modules

A module is just a directory containing `.tf` files. Every configuration you have already written is a module — the *root* module.

## Standard layout

```
modules/s3/
├── main.tf        resources
├── variables.tf   inputs, typed and described
├── outputs.tf     exports
├── versions.tf    required_version + provider constraints
└── README.md      usage, inputs table, outputs table
```

## Calling one

```hcl
module "assets" {
  source = "../modules/s3"

  bucket_name       = "cyberz-dev-assets"
  enable_versioning = true
  tags              = { Environment = "dev" }
}

# reference its outputs
output "bucket" {
  value = module.assets.bucket_id
}
```

## Sources

```hcl
source = "./modules/s3"                                          # local
source = "terraform-aws-modules/vpc/aws"                         # registry
version = "~> 5.13"                                              # ALWAYS pin registry modules
source = "git::https://github.com/org/repo.git//s3?ref=v1.2.0"   # git, pinned tag
```

An unpinned remote module can change between two `init` runs. Pin everything.

## Rules

1. **No `provider` blocks inside a module.** Modules inherit providers from their caller. A hardcoded provider makes the module unusable in multi-region or multi-account setups.
2. **Pin tightly in the root, loosely in the module.** Root: `~> 6.0`. Module: `>= 5.0`.
3. **Output generously.** Adding an output later costs nothing. A caller blocked by a missing output has to fork you.
4. **Validate at the boundary.** A `validation` block fails in milliseconds; a bad value discovered mid-`apply` leaves half-built infrastructure.
5. **Keep nesting shallow.** Root → module is fine. Four levels deep and nobody can trace where a value came from.
6. **Version your modules.** Tag them. `?ref=v1.2.0` means an upgrade is a deliberate, reviewable commit.

## When NOT to write a module

A module that wraps a single resource and passes through every argument adds indirection and no value. Write the resource. Reach for a module when there is a *pattern* worth naming — "a bucket that is always encrypted, versioned and private" is a pattern; "a bucket" is not.
