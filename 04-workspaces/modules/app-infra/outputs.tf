output "public_ips" {
  description = "Public IPs of the instances"
  value       = aws_instance.this[*].public_ip
}

output "bucket_id" {
  description = "Bucket name"
  value       = aws_s3_bucket.this.id
}

output "table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.this.name
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}
