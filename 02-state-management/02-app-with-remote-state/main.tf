# A deliberately small stack. The point is not the resources, it is that
# `terraform.tfstate` for this directory lives in S3, not on your laptop.

resource "aws_s3_bucket" "app" {
  bucket = "${var.env}-${var.bucket_name}"

  tags = {
    Name        = "${var.env}-${var.bucket_name}"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "app" {
  bucket = aws_s3_bucket.app.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
