terraform {
  required_version = ">= 0.8.6"
}

data "aws_availability_zones" "main" {}

data "aws_ami" "base" {
  most_recent      = true
  owners           = ["${lookup(var.map_owner,lower(var.os))}"]
  executable_users = ["all"]

  filter {
    name   = "name"
    values = ["*${lookup(var.map_base_image_name,lower(var.os))}*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
