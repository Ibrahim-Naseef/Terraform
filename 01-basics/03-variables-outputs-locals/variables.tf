variable "project" {
  description = "Project slug used in every resource name"
  type        = string
  default     = "cyberz"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "suffixes" {
  description = "List of bucket suffixes to generate names for"
  type        = list(string)
  default     = ["logs", "assets", "backups"]
}

variable "env_sizes" {
  description = "Map of environment name to node count"
  type        = map(number)
  default     = {
    dev  = 1
    stg  = 2
    prod = 4
  }
}

variable "extra_tags" {
  description = "Additional tags merged into the common tag set"
  type        = map(string)
  default     = {}
}

# An object type gives you a typed, validated struct instead of a loose map.
variable "app_config" {
  description = "Application settings"
  type        = object({
    port         = number
    enable_https = bool
    replicas     = optional(number, 2)
  })
  default = {
    port         = 8000
    enable_https = true
  }

  validation {
    condition     = var.app_config.port > 1024 && var.app_config.port < 65536
    error_message = "app_config.port must be an unprivileged port between 1025 and 65535."
  }
}
