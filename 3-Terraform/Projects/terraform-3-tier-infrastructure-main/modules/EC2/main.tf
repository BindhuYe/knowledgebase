resource "aws_instance" "ec2_instance" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  subnet_id       = var.subnet_id
  security_groups = var.security_group_id

  tags = {
    Name = "${var.instance_name}"
  }
}