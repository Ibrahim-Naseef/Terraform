resource "aws_default_vpc" "this" {}

resource "aws_security_group" "this" {
  name        = "${var.env}-automate-sg"
  description = "Managed by Terraform - web + SSH access"
  vpc_id      = aws_default_vpc.this.id

  tags = {
    Name = "${var.env}-automate-sg"
  }
}

# Rules are separate resources rather than inline blocks. Inline `ingress`
# blocks force a full-rule replacement on every change; discrete rule
# resources let Terraform add/remove one rule at a time.
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.ssh_allowed_cidrs)

  security_group_id = aws_security_group.this.id
  description       = "SSH"
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web" {
  for_each = toset(["80", "8000"])

  security_group_id = aws_security_group.this.id
  description       = "HTTP ${each.value}"
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
