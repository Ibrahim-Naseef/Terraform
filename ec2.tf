# Key pair
resource "aws_key_pair" "my_keypair" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC and SG
resource "aws_default_vpc" "my_vpc" {
}

resource "aws_security_group" "my_sg" {
  name        = "automate-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.my_vpc.id #interpolation

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH from anywhere"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from anywhere"
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Custom HTTP from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

# ec2
resource "aws_instance" "my_ec2" {
  key_name        = aws_key_pair.my_keypair.key_name
  security_groups = [aws_security_group.my_sg.name]
  instance_type   = var.aws_instance_type
  ami             = var.ec2_ami_id

  root_block_device {
    volume_size = var.aws_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = "my-ec2-instance"
  }
}
