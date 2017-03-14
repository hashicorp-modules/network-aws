resource "aws_instance" "bastion" {
  count = "${length(var.vpc_cidrs_public)}"

  ami           = "${module.images.base_image}"
  instance_type = "${var.bastion_instance_type}"
  key_name      = "${aws_key_pair.main.key_name}"
  subnet_id     = "${element(aws_subnet.public.*.id,count.index)}"

  vpc_security_group_ids = [
    "${aws_security_group.egress_public.id}",
    "${aws_security_group.bastion_ssh.id}",
  ]

  tags {
    Name = "${var.environment_name}-bastion-${count.index}"
  }
}
