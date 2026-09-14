variable "aws_instance_type" {
  default = "t3.micro"
}

variable "aws_root_storage_size" {
  default = 15
  type    = number
}

variable "ec2_ami_id" {
  default = "ami-01a00762f46d584a1"
  type    = string
}

variable "s3_bucket_name" {
  description = "Globally-unique name for the S3 bucket provisioned via modules/s3"
  type        = string
  default     = "terraform-bucket-coder"
}
