variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID"
  type        = string
}

variable "hash_key" {
  description = "DynamoDB partition key"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Root volume size in GiB"
  type        = number
  default     = 10
}

variable "enable_versioning" {
  description = "Enable S3 versioning"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow destroying a non-empty bucket"
  type        = bool
  default     = false
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}
