resource "aws_security_group" "bastion_ssh" {
  name        = "${var.environment_name}-bastion_ssh"
  description = "${var.environment_name}-bastion_ssh"
  vpc_id      = "${aws_vpc.main.id}"
}

resource "aws_security_group_rule" "bastion_ssh" {
  security_group_id = "${aws_security_group.bastion_ssh.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}
