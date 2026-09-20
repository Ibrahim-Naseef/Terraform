output "workspace" {
  description = "Currently selected workspace"
  value       = terraform.workspace
}

output "resource_prefix" {
  description = "Name prefix applied to every resource in this workspace"
  value       = local.name
}

output "instance_public_ips" {
  description = "Public IPs of the instances in this workspace"
  value       = module.infra.public_ips
}

output "bucket_name" {
  description = "Bucket created for this workspace"
  value       = module.infra.bucket_id
}

output "dynamodb_table" {
  description = "Table created for this workspace"
  value       = module.infra.table_name
}
