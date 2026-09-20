terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

variable "greeting" {
  description = "Text written to the file"
  type        = string
  default     = "hello"
}

resource "local_file" "greeting" {
  filename = "${path.module}/greeting.txt"
  content  = "${var.greeting}\n"
}

output "content" {
  description = "What was written"
  value       = local_file.greeting.content
}
