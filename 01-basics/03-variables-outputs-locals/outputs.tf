output "name_prefix" {
  description = "Prefix applied to every resource name"
  value       = local.name_prefix
}

output "common_tags" {
  description = "Tag map merged from defaults and extra_tags"
  value       = local.common_tags
}

output "instance_size" {
  description = "Instance size chosen by the conditional expression"
  value       = local.instance_size
}

output "bucket_names" {
  description = "Names built by a for expression over var.suffixes"
  value       = local.bucket_names
}

output "multi_node_envs" {
  description = "Environments with more than one node (filtered for expression)"
  value       = local.large_envs
}

output "resolved_replicas" {
  description = "Demonstrates optional() supplying a default inside an object type"
  value       = var.app_config.replicas
}
