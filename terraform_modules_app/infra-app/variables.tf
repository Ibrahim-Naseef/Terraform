variable "env" {
  description = "Environment name"
  type        = string
}

variable "instance_count"{
    description = "Number of EC2 instances to create"
    type = number
}

variable "instance_type"{
    description = "This is the instance type"
    type = string
}

variable "ami_id"{
    description = "This is the AMI ID"
    type = string
}

variable "hash_key" {
  description = "This is the Hask key value"
  type = string
}

variable "bucket_name" {
  description = "This is the S3 bucket name"
  type = string
}