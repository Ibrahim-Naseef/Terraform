# Module: s3

A secure-by-default S3 bucket: versioning on, SSE-S3 encryption, public access blocked, optional lifecycle expiry for old versions.

## Usage

```hcl
module "assets" {
  source = "../modules/s3"

  bucket_name               = "cyberz-dev-assets"
  enable_versioning         = true
  lifecycle_expiration_days = 30

  tags = {
    Environment = "dev"
  }
}
```

## Inputs

| Name | Type | Default | Required | Description |
|---|---|---|:---:|---|
| `bucket_name` | `string` | — | yes | Globally unique bucket name. Validated against S3 naming rules. |
| `enable_versioning` | `bool` | `true` | no | Turn object versioning on or off. |
| `force_destroy` | `bool` | `false` | no | Let `terraform destroy` delete a non-empty bucket. |
| `block_public_access` | `bool` | `true` | no | Apply the full public access block. |
| `lifecycle_expiration_days` | `number` | `0` | no | Expire noncurrent versions after N days. `0` disables. |
| `tags` | `map(string)` | `{}` | no | Extra tags merged onto the bucket. |

## Outputs

| Name | Description |
|---|---|
| `bucket_id` | Bucket name |
| `bucket_arn` | Bucket ARN |
| `bucket_regional_domain_name` | Regional domain name |

## Notes

- No `provider` block. A module inherits the provider from its caller; declaring one inside a module makes the module impossible to use with aliased providers.
- `versions.tf` uses a permissive `>=` constraint. Pin exact versions in the *root* module, not in shared modules.
