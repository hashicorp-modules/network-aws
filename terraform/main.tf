terraform {
  required_version = ">= 0.8.6"
}

data "aws_availability_zones" "main" {}

module "images" {
  source = "git@github.com:hashicorp-modules/images-aws.git//terraform"

  os = "ubuntu"
}
