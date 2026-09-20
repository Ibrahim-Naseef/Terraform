# Module: app-infra

One environment's worth of infrastructure: key pair, security group, N EC2 instances, an S3 bucket and a DynamoDB table. Everything is sized by input, so the same module produces a `t3.micro` dev box or a two-node `t3.small` prod pair.

## Inputs

| Name | Type | Default | Required |
|---|---|---|:---:|
| `name` | `string` | — | yes |
| `env` | `string` | — | yes |
| `ami_id` | `string` | — | yes |
| `hash_key` | `string` | — | yes |
| `public_key_path` | `string` | — | yes |
| `instance_count` | `number` | `1` | no |
| `instance_type` | `string` | `"t3.micro"` | no |
| `root_volume_size` | `number` | `10` | no |
| `enable_versioning` | `bool` | `true` | no |
| `force_destroy` | `bool` | `false` | no |

## Outputs

`public_ips`, `bucket_id`, `table_name`, `security_group_id`
