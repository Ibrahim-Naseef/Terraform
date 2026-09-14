# 🌍 Terraform on AWS — EC2 + S3

Spin up a ready-to-SSH EC2 instance and a hardened S3 bucket on AWS with a single `terraform apply`.

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-844FBA?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-ap--south--1-FF9900?logo=amazon-aws&logoColor=white)
![Provider](https://img.shields.io/badge/aws%20provider-~%3E6.0-232F3E)
![License](https://img.shields.io/badge/license-MIT-green)

---

## 📐 What this builds

```
                        ┌────────────────────────────┐
                        │        AWS Region            │
                        │        ap-south-1            │
                        │                              │
   Your machine         │   ┌──────────────────────┐   │
   ┌──────────┐  SSH 22 │   │   Default VPC         │   │
   │ terraform│ ───────►│   │  ┌─────────────────┐  │   │
   │  apply   │  HTTP 80│   │  │  EC2 instance    │  │   │
   └──────────┘  8000   │   │  │  (aws_instance)  │  │   │
                        │   │  │  + key pair      │  │   │
                        │   │  │  + security group│  │   │
                        │   │  └─────────────────┘  │   │
                        │   └──────────────────────┘   │
                        │                              │
                        │   ┌──────────────────────┐   │
                        │   │  S3 bucket (module)   │   │
                        │   │  versioned · encrypted│   │
                        │   │  public access blocked│   │
                        │   └──────────────────────┘   │
                        └────────────────────────────┘
```

| Resource | File | Purpose |
|---|---|---|
| `aws_key_pair` | `ec2.tf` | Registers your public key for SSH access |
| `aws_default_vpc` | `ec2.tf` | Uses the account's default VPC |
| `aws_security_group` | `ec2.tf` | Opens ports `22` (SSH), `80` (HTTP), `8000` (custom) inbound, all outbound |
| `aws_instance` | `ec2.tf` | The EC2 instance itself (`t3.micro` by default) |
| `module.s3_bucket` | `s3.tf` → `modules/s3` | Versioned, encrypted, publicly-blocked S3 bucket |

---

## 📁 Project layout

```
Terraform/
├── terraform.tf              # Terraform + provider version constraints
├── providers.tf              # AWS provider (region: ap-south-1)
├── variables.tf              # Root input variables & defaults
├── ec2.tf                    # Key pair, security group, EC2 instance
├── s3.tf                     # Calls the S3 module below
├── outputs.tf                # EC2 IPs/DNS + S3 bucket name/ARN
├── new-file.tf                # Sandbox file (local_file example, disabled)
├── terraform_install.sh       # Helper: installs the Terraform CLI on Ubuntu/Debian
├── .gitignore                 # Keeps state, vars, and keys out of git
└── modules/
    └── s3/                    # 🆕 Reusable S3 bucket module
        ├── main.tf            #    bucket + versioning + encryption + public-access block
        ├── variables.tf       #    bucket_name, enable_versioning, force_destroy, tags
        └── outputs.tf         #    bucket_id, bucket_arn, bucket_regional_domain_name
```

> **What changed:** the bucket used to be a single commented-out resource in `s3.tf`.
> It's now a proper module under `modules/s3/`, with versioning, AES-256 default
> encryption, and a public-access block on by default — call it from any root
> config, not just this one.

---

## ✅ Prerequisites

- An AWS account + credentials configured (`aws configure`, or env vars)
- Terraform CLI `>= 1.5` — no Terraform yet? Run:
  ```bash
  chmod +x terraform_install.sh
  ./terraform_install.sh
  ```
- An SSH key pair named `terra-key-ec2` / `terra-key-ec2.pub` in this directory
  (referenced by `ec2.tf`'s `aws_key_pair` resource — generate one with
  `ssh-keygen -t rsa -b 4096 -f terra-key-ec2 -N ""` if you don't have it)

---

## 🚀 Usage

```bash
# 1. Initialize providers & modules
terraform init

# 2. Preview the plan
terraform plan

# 3. Ship it
terraform apply

# 4. Grab the outputs
terraform output
```

Customize any input in `variables.tf`, or override on the CLI:

```bash
terraform apply \
  -var="aws_instance_type=t3.small" \
  -var="s3_bucket_name=my-unique-bucket-name"
```

When you're done:

```bash
terraform destroy
```

---

## 🔧 Key variables

| Variable | Default | Description |
|---|---|---|
| `aws_instance_type` | `t3.micro` | EC2 instance size |
| `aws_root_storage_size` | `15` | Root EBS volume size (GB) |
| `ec2_ami_id` | `ami-01a00762f46d584a1` | AMI to launch (region-specific!) |
| `s3_bucket_name` | `terraform-bucket-coder` | Must be globally unique across all of AWS |

---

## 📤 Outputs

| Output | Description |
|---|---|
| `ec2_public_ip` / `ec2_public_dns` | Reach your instance over the internet |
| `ec2_private_ip` / `ec2_private_dns` | Internal VPC addressing |
| `s3_bucket_name` | Name of the provisioned bucket |
| `s3_bucket_arn` | ARN for IAM policies / cross-service references |

---

## ⚠️ Security notes

- The security group opens `22`, `80`, and `8000` to `0.0.0.0/0` — fine for a
  demo, **narrow the CIDR blocks before using this in anything real**.
- `.gitignore` excludes `*.tfstate`, `*.tfvars`, and the private key —
  never commit real state files or private keys to version control.
- The S3 module blocks all public access and encrypts objects at rest by
  default; only relax `force_destroy` / public-access settings intentionally.

---

## 🗺️ Roadmap ideas

- [ ] Swap the default VPC for a purpose-built VPC + subnets
- [ ] Add an Elastic IP so the public address survives instance replacement
- [ ] Parameterize the AWS region instead of hardcoding `ap-south-1`
- [ ] Add a remote backend (S3 + DynamoDB) for team-shared state

---

## 🪪 License

MIT — do whatever you want with it, just don't blame me for your AWS bill.
