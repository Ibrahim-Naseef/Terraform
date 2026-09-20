# The smallest possible Terraform configuration: no cloud account needed.
# Use this to prove out the init -> plan -> apply -> destroy loop before
# touching AWS.

resource "local_file" "hello" {
  filename        = "${path.module}/automate.txt"
  content         = "Hello from Terraform! Generated at apply time.\n"
  file_permission = "0644"
}
