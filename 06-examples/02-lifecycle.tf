resource "local_file" "lifecycle_demo" {
  filename = "${path.module}/out/lifecycle.txt"
  content  = "v1\n"

  lifecycle {
    # Stand up the replacement before tearing down the original.
    # Essential for anything serving traffic.
    create_before_destroy = true

    # Stop fighting a value something else owns (an autoscaler, a
    # deploy pipeline). Terraform stops proposing to "fix" it.
    ignore_changes = [file_permission]

    # `terraform destroy` will refuse. Use on state buckets, prod databases.
    # prevent_destroy = true

    # Fail the PLAN, not the apply, when an assumption is violated.
    precondition {
      condition     = length(local_file.lifecycle_demo.content) > 0
      error_message = "content must not be empty."
    }

    # Verify AFTER apply that reality matches the intent.
    postcondition {
      condition     = self.filename != ""
      error_message = "filename should have been set."
    }
  }
}
