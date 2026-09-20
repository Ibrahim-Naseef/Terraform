# Run with:  cd terraform-test && terraform test
#
# `terraform test` (>= 1.6) is a real testing framework: each `run` block
# executes a plan or apply and asserts on the result.

variables {
  greeting = "hello"
}

run "default_greeting_is_written" {
  command = plan

  assert {
    condition     = local_file.greeting.content == "hello\n"
    error_message = "Expected the default greeting to be written."
  }
}

run "custom_greeting_is_respected" {
  command = plan

  variables {
    greeting = "namaste"
  }

  assert {
    condition     = local_file.greeting.content == "namaste\n"
    error_message = "Variable override did not reach the resource."
  }
}

run "file_is_actually_created" {
  command = apply

  assert {
    condition     = local_file.greeting.filename != ""
    error_message = "Expected a filename after apply."
  }
}
