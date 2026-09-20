# `moved` renames a resource in state without destroying anything.
#
# Before: resource "local_file" "old_name"
# After:  resource "local_file" "renamed"
#
# Without this block Terraform sees a deletion plus a creation. With it,
# Terraform just relabels the existing object.

resource "local_file" "renamed" {
  filename = "${path.module}/out/renamed.txt"
  content  = "I used to be called old_name\n"
}

moved {
  from = local_file.old_name
  to   = local_file.renamed
}

# `removed` (Terraform >= 1.7) drops a resource from state while leaving the
# real object alive - the declarative replacement for `terraform state rm`.
#
# removed {
#   from = local_file.retired
#
#   lifecycle {
#     destroy = false
#   }
# }
