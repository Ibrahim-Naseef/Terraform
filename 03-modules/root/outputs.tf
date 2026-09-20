output "assets_bucket" {
  description = "Name of the assets bucket"
  value       = module.assets_bucket.bucket_id
}

output "logs_bucket" {
  description = "Name of the logs bucket"
  value       = module.logs_bucket.bucket_id
}

output "web_public_ips" {
  description = "Public IPs of the web instances"
  value       = module.web.public_ips
}
