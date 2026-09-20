resource "aws_key_pair" "this" {
  key_name   = "${var.name}-key"
  public_key = file(var.public_key_path)
  tags       = var.tags
}

resource "aws_default_vpc" "this" {}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Managed by Terraform for ${var.name}"
  vpc_id      = aws_default_vpc.this.id

  tags = merge({ Name = "${var.name}-sg" }, var.tags)
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.ssh_allowed_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "SSH"
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "app" {
  for_each = toset([for p in var.allowed_ports : tostring(p)])

  security_group_id = aws_security_group.this.id
  description       = "App port ${each.value}"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.this.id
  description       = "Allow all outbound"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.this.key_name
  vpc_security_group_ids = [aws_security_group.this.id]

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(
    { Name = "${var.name}-${count.index + 1}" },
    var.tags
  )
}
