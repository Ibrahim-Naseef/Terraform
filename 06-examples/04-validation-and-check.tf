variable "environment" {
  description = "Environment name, validated at plan time"
  type        = string
  default     = "dev"

  # Cheap, instant feedback. Runs before a single API call is made.
  validation {
    condition     = contains(["dev", "stg", "prod"], var.environment)
    error_message = "environment must be dev, stg or prod."
  }
}

variable "port" {
  description = "Application port"
  type        = number
  default     = 8080

  validation {
    condition     = var.port > 1024 && var.port <= 65535
    error_message = "port must be an unprivileged port (1025-65535)."
  }
}

# `check` blocks (Terraform >= 1.5) WARN without failing. Use them for
# conditions that are worth surfacing but should not block a deploy.
check "prod_uses_standard_port" {
  assert {
    condition     = var.environment != "prod" || var.port == 443
    error_message = "prod normally serves on 443. Confirm this is intentional."
  }
}
