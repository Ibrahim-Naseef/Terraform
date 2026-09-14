variable "bucket_name" {
  description = "Globally-unique name for the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Whether object versioning is enabled on the bucket"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the bucket even if it still contains objects"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to merge onto the bucket"
  type        = map(string)
  default     = {}
}
