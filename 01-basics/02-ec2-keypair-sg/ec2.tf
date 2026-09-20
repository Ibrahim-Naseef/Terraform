resource "aws_instance" "this" {
  for_each = var.instances

  ami                    = var.ec2_ami_id
  instance_type          = each.value
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  root_block_device {
    # prod gets a bigger disk; everything else uses the variable
    volume_size           = var.env == "prod" ? 20 : var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_tokens = "required" # IMDSv2 only
  }

  tags = {
    Name = "${var.env}-${each.key}"
  }
}
