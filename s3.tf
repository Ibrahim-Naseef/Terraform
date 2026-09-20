# # Original commented-out resource, kept for reference:
# #
# # resource aws_s3_bucket my_bucket {
# #   bucket = "terraform-bucket-coder"
# # }
# #
# # Now provisioned through the reusable module in ./modules/s3, which adds
# # versioning, default encryption, and a public-access block on top of the
# # plain bucket above.

# module "s3_bucket" {
#   source = "./modules/s3"

#   bucket_name       = var.s3_bucket_name
#   enable_versioning = true

#   tags = {
#     Project = "terraform-ec2-s3-demo"
#   }
# }
