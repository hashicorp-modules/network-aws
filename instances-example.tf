resource "aws_instance" "example" {
  count = "${length(var.example_instance_count)}"

  ami           = "${module.images.base_image}"
  instance_type = "${var.example_instance_type}"
  key_name      = "${module.ssh_key.ssh_key_name}"
  subnet_id     = "${element(module.network.subnet_private_ids,count.index)}"

  vpc_security_group_ids = [
    "${module.network.security_group_egress_id}",
    "${aws_security_group.example.id}",
  ]

  tags {
    Name = "${var.environment_name}-bastion-${count.index}"
  }
}
