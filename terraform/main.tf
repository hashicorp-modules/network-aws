data "aws_availability_zones" "main" {}

variable "os_user" {
  default = {
    ubuntu = "ubuntu"
    rhel   = "ec2-user"
  }
}

variable "os_name_filter" {
  default = {
    ubuntu = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20170307"
    rhel   = "RHEL-7.3_HVM_GA-20161026-x86_64-1-Hourly2-GP2"
  }
}

variable "os_owner_filter" {
  default = {
    ubuntu = "099720109477" # Canonical
    rhel   = "309956199498" # Red Hat, Inc.
  }
}

data "aws_ami" "main" {
  owners = ["${lookup(var.os_owner_filter,var.os)}"]

  filter {
    name   = "name"
    values = ["${lookup(var.os_name_filter,var.os)}"]
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
