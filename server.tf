terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "account_number"{}

resource "aws_default_vpc" "default_vpc"{

}

#TODO: complete the below
data "app_server_ami" "ubuntu"{
  most_recent = true

  filter{
    name = "name"
    values = [""]
  }
}

resource "aws_instance" "application_server" {
  tags = {
    "name" = "Application Server" 
  }
  ami = app_server_ami.ubuntu.id
  instance_type = "t4g.medium"
  security_groups = [ aws_security_group.application_server_sg ]
  user_data = file("setup.sh")
}

resource "aws_security_group" "application_server_sg" {
  name = "Application Server Security Group"
  vpc_id = aws_default_vpc.default_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "application_server_ingress_rule"{
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.application_server_sg.id
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "application_server_egress_rule"{
  cidr_ipv4 = "0.0.0.0/0"
  security_group_id = aws_security_group.application_server_sg.id
  ip_protocol = "tcp"
}