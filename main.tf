terraform {
  required_version = ">= 0.11.5"
}

data "aws_availability_zones" "main" {}

resource "aws_vpc" "main" {
  count = "${var.create && var.create_vpc ? 1 : 0}"

  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_subnet" "public" {
  count = "${var.create ? length(var.vpc_cidrs_public) : 0}"

  # TODO: Workaround for https://github.com/hashicorp/terraform/issues/11210, remove concat once issue #11210 is fixed
  vpc_id                  = "${var.create_vpc ? element(concat(aws_vpc.main.*.id, list("")), 0) : var.vpc_id}" # TODO: Workaround for issue #11210
  availability_zone       = "${element(data.aws_availability_zones.main.names, count.index)}"
  cidr_block              = "${element(var.vpc_cidrs_public, count.index)}"
  map_public_ip_on_launch = true

  tags = "${merge(var.tags, map("Name", format("%s-public-%d", var.name, count.index + 1)))}"
}

resource "aws_internet_gateway" "main" {
  count  = "${var.create ? 1 : 0}"
  vpc_id = "${var.create_vpc ? element(concat(aws_vpc.main.*.id, list("")), 0) : var.vpc_id}" # TODO: Workaround for issue #11210

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_route_table" "public" {
  count  = "${var.create ? 1 : 0}"
  vpc_id = "${var.create_vpc ? element(concat(aws_vpc.main.*.id, list("")), 0) : var.vpc_id}" # TODO: Workaround for issue #11210

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = "${merge(var.tags, map("Name", format("%s-public", var.name)))}"
}

resource "aws_route_table_association" "public" {
  count = "${var.create ? length(var.vpc_cidrs_public) : 0}"

  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "nat" {
  count = "${var.create && var.nat_count != "-1" ? var.nat_count : var.create ? length(var.vpc_cidrs_public) : 0}"
  vpc   = true

  tags = "${merge(var.tags, map("Name", format("%s-%d", var.name, count.index + 1)))}"
}

resource "aws_nat_gateway" "nat" {
  count = "${var.create && var.nat_count != "-1" ? var.nat_count : var.create ? length(var.vpc_cidrs_public) : 0}"

  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  tags = "${merge(var.tags, map("Name", format("%s-%d", var.name, count.index + 1)))}"
}

resource "aws_subnet" "private" {
  count = "${var.create ? length(var.vpc_cidrs_private) : 0}"

  vpc_id                  = "${var.create_vpc ? element(concat(aws_vpc.main.*.id, list("")), 0) : var.vpc_id}" # TODO: Workaround for issue #11210
  availability_zone       = "${element(data.aws_availability_zones.main.names, count.index)}"
  cidr_block              = "${element(var.vpc_cidrs_private, count.index)}"
  map_public_ip_on_launch = false

  tags = "${merge(var.tags, map("Name", format("%s-private-%d", var.name, count.index + 1)))}"
}

resource "aws_route_table" "private_subnet" {
  count = "${var.create ? length(var.vpc_cidrs_private) : 0}"

  vpc_id = "${var.create_vpc ? element(concat(aws_vpc.main.*.id, list("")), 0) : var.vpc_id}" # TODO: Workaround for issue #11210

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat.*.id, count.index)}"
  }

  tags = "${merge(var.tags, map("Name", format("%s-private-%d", var.name, count.index + 1)))}"
}

resource "aws_route_table_association" "private" {
  count = "${var.create ? length(var.vpc_cidrs_private) : 0}"

  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_subnet.*.id, count.index)}"
}

module "consul_auto_join_instance_role" {
  source = "github.com/hashicorp-modules/consul-auto-join-instance-role-aws"

  create = "${var.create && var.bastion_count > 0 ? 1 : 0}"
  name   = "${var.name}"
}

data "aws_ami" "hashistack" {
  count       = "${var.create && var.image_id == "" && var.bastion_count > 0 ? 1 : 0}"
  most_recent = true
  owners      = ["${var.ami_owner}"]
  name_regex  = "hashistack-image_${lower(var.release_version)}_nomad_${lower(var.nomad_version)}_vault_${lower(var.vault_version)}_consul_${lower(var.consul_version)}_${lower(var.os)}_${var.os_version}.*"

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ssh_keypair_aws" {
  source = "github.com/hashicorp-modules/ssh-keypair-aws"

  # This doesn't set the "key_name" attribute on aws_instance.bastion when uncommented,
  # there always seems to be 1.) a dirty plan that fails to set the value on apply
  # or 2.) the plan fails because of a count interpolation error in the tls-private-key
  # module. Commenting this out just creates an ssh_keypair regardless if one is passed in,
  # so not too big of a deal, worst case scenario is you have an un-used keypair.

  # EDIT: 1: Was resolved using a concat on module.ssh_keypair_aws.$attribute,
  # 2: When using the "advanced" example and the below argument "create" is uncommented,
  # the variable ${var.ssh_key_name} is computed, throwing the error
  # "value of 'count' cannot be computed". As a workaround, we're passing in a static
  # variable ${var.ssh_key_override} until the below issue is fixed.
  # https://github.com/hashicorp/terraform/issues/12570#issuecomment-310236691
  # https://github.com/hashicorp/terraform/issues/4149
  # https://github.com/hashicorp/terraform/issues/10857
  # https://github.com/hashicorp/terraform/issues/13980
  # create = "${var.create && var.ssh_key_name != "" && var.bastion_count > 0 ? 1 : 0}" # TODO: Uncomment once issue #4149 is resolved
  create = "${var.create && !var.ssh_key_override && var.bastion_count > 0 ? 1 : 0}" # TODO: Remove once issue #4149 is resolved
  name   = "${var.name}"
}

data "template_file" "bastion_init" {
  count    = "${var.create && var.bastion_count != -1 ? var.bastion_count : var.create ? length(var.vpc_cidrs_public) : 0}"
  template = "${file("${path.module}/templates/init-systemd.sh.tpl")}"

  vars = {
    hostname  = "${var.name}-bastion-${count.index + 1}"
    user_data = "${var.user_data != "" ? var.user_data : "echo No custom user_data"}"
  }
}

module "bastion_consul_client_sg" {
  source = "github.com/hashicorp-modules/consul-client-ports-aws"

  create      = "${var.create && var.bastion_count > 0 ? 1 : 0}"
  name        = "${var.name}-bastion-consul-client"
  vpc_id      = "${var.create_vpc ? element(concat(aws_vpc.main.*.id, list("")), 0) : var.vpc_id}" # TODO: Workaround for issue #11210
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group" "bastion" {
  count       = "${var.create && var.bastion_count > 0 ? 1 : 0}"
  name_prefix = "${var.name}-bastion-"
  description = "Security Group for ${var.name} Bastion hosts"
  vpc_id      = "${var.create_vpc ? element(concat(aws_vpc.main.*.id, list("")), 0) : var.vpc_id}" # TODO: Workaround for issue #11210

  tags = "${merge(var.tags, map("Name", format("%s-bastion", var.name)))}"
}

resource "aws_security_group_rule" "ssh" {
  count = "${var.create && var.bastion_count > 0 ? 1 : 0}"

  security_group_id = "${aws_security_group.bastion.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_public" {
  count = "${var.create && var.bastion_count > 0 ? 1 : 0}"

  security_group_id = "${aws_security_group.bastion.id}"
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_instance" "bastion" {
  count = "${var.create && var.bastion_count != -1 ? var.bastion_count : var.create ? length(var.vpc_cidrs_public) : 0}"

  iam_instance_profile = "${var.instance_profile != "" ? var.instance_profile : module.consul_auto_join_instance_role.instance_profile_id}"
  ami                  = "${var.image_id != "" ? var.image_id : element(concat(data.aws_ami.hashistack.*.id, list("")), 0)}" # TODO: Workaround for issue #11210
  instance_type        = "${var.instance_type}"
  key_name             = "${var.ssh_key_name != "" ? var.ssh_key_name : module.ssh_keypair_aws.name}"
  user_data            = "${element(data.template_file.bastion_init.*.rendered, count.index)}"
  subnet_id            = "${element(aws_subnet.public.*.id, count.index)}"

  vpc_security_group_ids = [
    "${module.bastion_consul_client_sg.consul_client_sg_id}",
    "${element(concat(aws_security_group.bastion.*.id, list("")), 0)}", # TODO: Workaround for issue #11210
  ]

  tags = "${merge(var.tags, map("Name", format("%s-bastion-%d", var.name, count.index + 1), "Consul-Auto-Join", var.name))}"
}
