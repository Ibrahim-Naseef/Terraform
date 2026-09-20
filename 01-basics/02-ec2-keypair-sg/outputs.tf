output "instance_public_ips" {
  description = "Public IP of each instance, keyed by instance name"
  value       = { for k, i in aws_instance.this : k => i.public_ip }
}

output "instance_public_dns" {
  description = "Public DNS of each instance, keyed by instance name"
  value       = { for k, i in aws_instance.this : k => i.public_dns }
}

output "security_group_id" {
  description = "ID of the security group attached to the instances"
  value       = aws_security_group.this.id
}
