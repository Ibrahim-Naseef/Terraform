output "file_path" {
  description = "Path of the file Terraform created"
  value       = local_file.hello.filename
}
