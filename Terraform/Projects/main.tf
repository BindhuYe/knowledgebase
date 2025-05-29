terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# # Create a VPC
# resource "aws_vpc" "example" {
#   cidr_block = "192.168.0.0/16"
#     tags = {
#     Name = "Jenkins-VPC"
#   }
# }
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name   = "aws_key"
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data = templatefile("./install.sh",{})
  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_key_pair" "instances" {
  key_name   = "aws_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTet8H9EVl3KUcONCybM0QRjdgbisQAAhNxhnH9FV0sCO0skRKT3o+1Yh2RfbPzpgIvMRB4irQI8g5fPUMbHrCrNIg6b1S6kDsL37LjnoDjXTXlX4flsds0mWbKNaMWsPBTWtqW+S+O3+hD5N512RkoAOD0bQcfwDCs/oMVg0zND+S+ESJKKMtTKnP3doUhSBmdYMWzASiIuyWAXJN/7f+7yBmtdoRCzJqZOuAfMhEdNtZcf6cym5dYK6FOsCJjizo0xKShsRGJB/7hukUono7mb8LRBT8m3RR0ydrhzNbGF8SnTKxmeAE7ex/fQlNU+7XXWXBkebp9JtRLuybpFoL mmk@mkaramin-JKF66M3"
}

resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
 ingress                = [
   for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
}



output "ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "public_ip" {
  value=aws_instance.web.public_ip
}
