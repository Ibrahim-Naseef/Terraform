variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project slug used as a name prefix"
  type        = string
  default     = "cyberz"
}

variable "ami_id" {
  description = "AMI ID (region-specific)"
  type        = string
  default     = "ami-01a00762f46d584a1"
}

variable "hash_key" {
  description = "DynamoDB partition key name"
  type        = string
  default     = "studentID"
}
