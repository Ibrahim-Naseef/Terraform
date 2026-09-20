locals {
  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

# --- compute -----------------------------------------------------------
resource "aws_key_pair" "this" {
  key_name   = "${var.name}-key"
  public_key = file(var.public_key_path)
  tags       = local.tags
}

resource "aws_default_vpc" "this" {}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Managed by Terraform for ${var.name}"
  vpc_id      = aws_default_vpc.this.id
  tags        = merge({ Name = "${var.name}-sg" }, local.tags)
}

resource "aws_vpc_security_group_ingress_rule" "app" {
  for_each = toset(["22", "80", "8000"])

  security_group_id = aws_security_group.this.id
  description       = "Port ${each.value}"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = merge({ Name = "${var.name}-ec2-${count.index + 1}" }, local.tags)
}

# --- storage -----------------------------------------------------------
resource "aws_s3_bucket" "this" {
  bucket        = "${var.name}-bucket"
  force_destroy = var.force_destroy
  tags          = merge({ Name = "${var.name}-bucket" }, local.tags)
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- data --------------------------------------------------------------
resource "aws_dynamodb_table" "this" {
  name         = "${var.name}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  attribute {
    name = var.hash_key
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.env == "prod"
  }

  tags = merge({ Name = "${var.name}-table" }, local.tags)
}
