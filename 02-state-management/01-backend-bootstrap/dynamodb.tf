# State lock table.
#
# Without locking, two engineers running `terraform apply` at the same moment
# both read the same state, both write, and the second write silently erases
# the first one's resources from state. The table turns that race into a
# clean "Error acquiring the state lock".
#
# NOTE: Terraform 1.10+ can lock with an S3 object instead (`use_lockfile = true`),
# which removes the need for this table. Both approaches are shown in
# ../02-app-with-remote-state/backend.tf.
resource "aws_dynamodb_table" "lock" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST" # no idle cost; locks are tiny and rare
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  server_side_encryption {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.lock_table_name
  }
}
