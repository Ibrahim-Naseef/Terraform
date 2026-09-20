locals {
  name        = "${var.project}-${var.env}"
  common_tags = { Environment = var.env }
}

# Same module, two calls, two completely separate sets of resources.
# That is the whole point of a module: write once, instantiate many times.
module "assets_bucket" {
  source = "../modules/s3"

  bucket_name               = "${local.name}-assets"
  enable_versioning         = true
  lifecycle_expiration_days = 30
  tags                      = local.common_tags
}

module "logs_bucket" {
  source = "../modules/s3"

  bucket_name               = "${local.name}-logs"
  enable_versioning         = false
  force_destroy             = true
  lifecycle_expiration_days = 7
  tags                      = local.common_tags
}

module "web" {
  source = "../modules/ec2"

  name             = "${local.name}-web"
  ami_id           = var.ami_id
  instance_type    = var.env == "prod" ? "t3.small" : "t3.micro"
  instance_count   = var.env == "prod" ? 2 : 1
  root_volume_size = var.env == "prod" ? 20 : 10
  public_key_path  = "${path.root}/terra-key-ec2.pub"

  tags = local.common_tags
}
