resource "aws_security_group" "example" {
  name        = "${var.environment_name}-bastion_ssh"
  description = "${var.environment_name}-bastion_ssh"
  vpc_id      = "${module.network.vpc_id}"
}

resource "aws_security_group_rule" "example_ssh" {
  security_group_id        = "${aws_security_group.example.id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = "${module.network.security_group_bastion_id}"
}
