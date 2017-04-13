terraform {
  required_version = ">= 0.8.6"
}

data "aws_availability_zones" "main" {}

module "images" {
  source = "git@github.com:hashicorp-modules/images-aws.git?ref=2017-04-13"

  os = "${var.os}"
}
