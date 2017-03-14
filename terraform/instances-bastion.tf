module "ssh_key" {
  source = "git@github.com:hashicorp-modules/ssh-keypair.git//terraform"
  environment_name = "${var.environment_name}"
}

resource "aws_instance" "bastion" {
  count = "${length(var.vpc_cidrs_public)}"

  ami           = "${data.aws_ami.main.image_id}"
  instance_type = "${var.bastion_instance_type}"
  key_name      = "${module.ssh_key.key_name}"
  subnet_id     = "${element(aws_subnet.public.*.id,count.index)}"

  vpc_security_group_ids = [
    "${aws_security_group.egress_public.id}",
    "${aws_security_group.bastion_ssh.id}",
  ]

  tags {
    Name = "${var.environment_name}-bastion-${count.index}"
  }
}
