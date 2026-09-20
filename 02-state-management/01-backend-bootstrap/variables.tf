variable "aws_region" {
  description = "Region hosting the state bucket and lock table"
  type        = string
  default     = "ap-south-1"
}

variable "state_bucket_name" {
  description = "Globally unique name for the remote state bucket"
  type        = string
  default     = "cyberz-tf-remote-state"
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table used for state locking"
  type        = string
  default     = "cyberz-tf-state-lock"
}
