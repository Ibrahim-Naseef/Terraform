# Module: ec2

Key pair + security group + N EC2 instances, encrypted root volume, IMDSv2 enforced.

## Usage

```hcl
module "web" {
  source = "../modules/ec2"

  name            = "cyberz-dev-web"
  ami_id          = "ami-01a00762f46d584a1"
  instance_type   = "t3.micro"
  instance_count  = 2
  public_key_path = "${path.root}/terra-key-ec2.pub"

  allowed_ports     = [80, 443, 8000]
  ssh_allowed_cidrs = ["203.0.113.10/32"]

  tags = { Environment = "dev" }
}
```

## Inputs

| Name | Type | Default | Required |
|---|---|---|:---:|
| `name` | `string` | — | yes |
| `ami_id` | `string` | — | yes |
| `public_key_path` | `string` | — | yes |
| `instance_count` | `number` | `1` | no |
| `instance_type` | `string` | `"t3.micro"` | no |
| `root_volume_size` | `number` | `10` | no |
| `allowed_ports` | `list(number)` | `[80, 8000]` | no |
| `ssh_allowed_cidrs` | `list(string)` | `["0.0.0.0/0"]` | no |
| `tags` | `map(string)` | `{}` | no |

## Outputs

`instance_ids`, `public_ips`, `security_group_id`, `key_name`
