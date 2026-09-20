output "instance_ids" {
  description = "IDs of the created instances"
  value       = aws_instance.this[*].id
}

output "public_ips" {
  description = "Public IPs of the created instances"
  value       = aws_instance.this[*].public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}

output "key_name" {
  description = "Name of the generated key pair"
  value       = aws_key_pair.this.key_name
}
