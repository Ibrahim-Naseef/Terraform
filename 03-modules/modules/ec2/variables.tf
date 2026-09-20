variable "name" {
  description = "Base name for every resource this module creates"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "instance_count must be between 1 and 10."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID (region-specific)"
  type        = string
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size in GiB"
  type        = number
  default     = 10
}

variable "allowed_ports" {
  description = "Inbound TCP ports to open to the world"
  type        = list(number)
  default     = [80, 8000]
}

variable "ssh_allowed_cidrs" {
  description = "CIDRs allowed to SSH in"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Extra tags"
  type        = map(string)
  default     = {}
}
