variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "env" {
  description = "Environment name, used as a prefix on resource names"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stg", "prod"], var.env)
    error_message = "env must be one of: dev, stg, prod."
  }
}

variable "ec2_ami_id" {
  description = "AMI ID for the EC2 instances (region-specific)"
  type        = string
  default     = "ami-01a00762f46d584a1" # Ubuntu 24.04 LTS, ap-south-1
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB for non-prod environments"
  type        = number
  default     = 15
}

variable "public_key_path" {
  description = "Path to the public half of the SSH key pair (see scripts/generate_keypair.sh)"
  type        = string
  default     = "terra-key-ec2.pub"
}

variable "ssh_allowed_cidrs" {
  description = "CIDR ranges allowed to reach port 22. Lock this down to your own IP."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instances" {
  description = "Map of instance name => instance type"
  type        = map(string)
  default     = {
    "app-1" = "t3.micro"
    "app-2" = "t3.micro"
  }
}
