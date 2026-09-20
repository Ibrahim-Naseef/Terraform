variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project slug"
  type        = string
  default     = "cyberz"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-01a00762f46d584a1"
}
