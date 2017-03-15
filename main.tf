module "ssh_key" {
  source = "git@github.com:hashicorp-modules/ssh-keypair.git//terraform"

  environment_name = "${var.environment_name}"
}

module "vpc" {
  source = "./terraform"

  environment_name = "${var.environment_name}"
  os               = "ubuntu"
  ssh_key_name     = "${module.ssh_key.ssh_key_name}"
}
