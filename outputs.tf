# output "ec2_public_ip" {
#   value = aws_instance.my_ec2[*].public_ip
# }

# output "ec2_public_dns" {
#   value = aws_instance.my_ec2[*].public_dns
# }

# output "ec2_private_ip" {
#   value = aws_instance.my_ec2[*].private_ip
# }

# output "ec2_private_dns" {
#   value = aws_instance.my_ec2[*].private_dns
# }

# output "s3_bucket_name" {
#   description = "Name of the S3 bucket created by the modules/s3 module"
#   value       = module.s3_bucket.bucket_id
# }

# output "s3_bucket_arn" {
#   description = "ARN of the S3 bucket created by the modules/s3 module"
#   value       = module.s3_bucket.bucket_arn
# }

output "ec2_public_ip" {
  value = [ for ip in aws_instance.my_ec2 : ip.public_ip ]
}
