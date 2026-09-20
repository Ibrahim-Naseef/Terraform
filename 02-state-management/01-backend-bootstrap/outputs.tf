output "state_bucket" {
  description = "Bucket name to put in every other stack's backend block"
  value       = aws_s3_bucket.state.id
}

output "lock_table" {
  description = "DynamoDB table name for state locking"
  value       = aws_dynamodb_table.lock.name
}

output "backend_snippet" {
  description = "Copy-paste this into another stack's terraform block"
  value       = <<-EOT
    backend "s3" {
      bucket         = "${aws_s3_bucket.state.id}"
      key            = "<stack-name>/terraform.tfstate"
      region         = "${var.aws_region}"
      dynamodb_table = "${aws_dynamodb_table.lock.name}"
      encrypt        = true
    }
  EOT
}
