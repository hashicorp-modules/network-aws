terraform {
  required_version = ">= 0.8.6"
}

data "aws_availability_zones" "main" {}

module "images-aws" {
  source = "git@github.com:hashicorp-modules/images-aws.git?ref=dan-refactor"
  os     = "${var.os}"
}
