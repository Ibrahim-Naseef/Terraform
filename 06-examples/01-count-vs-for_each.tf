# ---------------------------------------------------------------------------
# count: addressed by POSITION. Removing "b" from the list renames c -> b,
# so Terraform destroys and recreates it.
# ---------------------------------------------------------------------------
variable "names_list" {
  description = "Demonstrates count indexing"
  type        = list(string)
  default     = ["a", "b", "c"]
}

resource "local_file" "by_count" {
  count = length(var.names_list)

  filename = "${path.module}/out/count-${var.names_list[count.index]}.txt"
  content  = "index ${count.index}\n"
}

# ---------------------------------------------------------------------------
# for_each: addressed by KEY. Removing "b" touches only "b".
# Try it: comment out "b" below, run plan with each block, compare.
# ---------------------------------------------------------------------------
resource "local_file" "by_foreach" {
  for_each = toset(var.names_list)

  filename = "${path.module}/out/foreach-${each.key}.txt"
  content  = "key ${each.key}\n"
}

# for_each over a map gives you both key and value
resource "local_file" "by_map" {
  for_each = {
    dev  = "t3.micro"
    prod = "t3.small"
  }

  filename = "${path.module}/out/map-${each.key}.txt"
  content  = "${each.key} runs ${each.value}\n"
}
