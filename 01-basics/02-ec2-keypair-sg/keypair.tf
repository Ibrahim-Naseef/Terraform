resource "aws_key_pair" "this" {
  key_name   = "${var.env}-terra-key-ec2"
  public_key = file(var.public_key_path)
}
