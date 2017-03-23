module "ssh_key" {
  source = "git@github.com:hashicorp-modules/ssh-keypair.git//terraform"

  environment_name = "${var.environment_name}"
}

module "images" {
  source = "git@github.com:hashicorp-modules/images-aws.git//terraform?ref=2017-03-23"

  os = "${var.os}"
}

module "network" {
  source = "./terraform"

  environment_name = "${var.environment_name}"
  os               = "${var.os}"
  ssh_key_name     = "${module.ssh_key.ssh_key_name}"
}
