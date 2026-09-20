output "bucket_id" {
  description = "Name of the application bucket"
  value       = aws_s3_bucket.app.id
}
