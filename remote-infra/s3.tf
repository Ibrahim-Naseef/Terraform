resource "aws_s3_bucket" "tf_bucket" {
  bucket = "my-tf-test-bucket-d1"

  tags = {
    Name        = "my-tf-test-bucket"
    Environment = "Dev"
  }
}