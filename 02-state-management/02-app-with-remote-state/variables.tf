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

variable "bucket_name" {
  description = "Application bucket name (must be globally unique)"
  type        = string
  default     = "cyberz-app-bucket"
}
