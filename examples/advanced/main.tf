resource "aws_vpc" "override" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

module "ssh_keypair_aws_override" {
  # source = "github.com/hashicorp-modules/ssh-keypair-aws"
  source = "../../../ssh-keypair-aws"

  name     = "${var.name}-override"
  rsa_bits = "${var.rsa_bits}"
}

module "consul_auto_join_instance_role_override" {
  # source = "github.com/hashicorp-modules/consul-auto-join-instance-role-aws"
  source = "../../../consul-auto-join-instance-role-aws"

  name = "${var.name}-override"
}

data "template_file" "bastion_user_data" {
  template = <<EOF
#!/bin/bash

echo "Configure Consul client"
cat <<CONFIG >/etc/consul.d/consul-client.json.example
{
  "datacenter": "${var.name}",
  "advertise_addr": "$local_ipv4",
  "data_dir": "/opt/consul/data",
  "client_addr": "0.0.0.0",
  "log_level": "INFO",
  "ui": true,
  "retry_join": ["provider=aws tag_key=Consul-Auto-Join tag_value=${var.name}"]
}
CONFIG
EOF
}

module "network_aws" {
  # source = "github.com/hashicorp-modules/network-aws"
  source = "../../../network-aws"

  create            = "${var.create}"
  name              = "${var.name}"
  create_vpc        = "${var.create_vpc}"
  vpc_id            = "${aws_vpc.override.id}"
  vpc_cidr          = "${aws_vpc.override.cidr_block}"
  vpc_cidrs_public  = "${var.vpc_cidrs_public}"
  nat_count         = "${var.nat_count}"
  vpc_cidrs_private = "${var.vpc_cidrs_private}"
  release_version   = "${var.release_version}"
  consul_version    = "${var.consul_version}"
  vault_version     = "${var.vault_version}"
  nomad_version     = "${var.nomad_version}"
  os                = "${var.os}"
  os_version        = "${var.os_version}"
  bastion_count     = "${var.bastion_count}"
  instance_profile  = "${module.consul_auto_join_instance_role_override.instance_profile_id}" # Override instance_profile
  instance_type     = "${var.instance_type}"
  user_data         = "${data.template_file.bastion_user_data.rendered}" # Custom user_data
  ssh_key_name      = "${module.ssh_keypair_aws_override.name}"
  ssh_key_override  = "true"
  tags              = "${var.tags}"
}
