variable "bucket_name" {
  description = "Globally unique name for the S3 bucket"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3-63 chars, lowercase letters, digits, hyphens or dots."
  }
}

variable "enable_versioning" {
  description = "Whether object versioning is enabled"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow Terraform to delete the bucket even if objects remain"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Apply a full public access block. Leave true unless hosting a public site."
  type        = bool
  default     = true
}

variable "lifecycle_expiration_days" {
  description = "Delete noncurrent object versions after this many days. 0 disables the rule."
  type        = number
  default     = 0
}

variable "tags" {
  description = "Additional tags merged onto the bucket"
  type        = map(string)
  default     = {}
}
