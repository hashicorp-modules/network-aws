//
// Variables
//
variable "environment_name" {
  type = "string"
}

variable "os" {
  type = "string"
}

variable "ssh_key_name" {
  type = "string"
}

//
// Variables w/ Defaults
//
variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "vpc_cidrs_public" {
  default = [
    "172.31.0.0/20",
    "172.31.16.0/20",
    "172.31.32.0/20",
  ]
}

variable "vpc_cidrs_private" {
  default = [
    "172.31.48.0/20",
    "172.31.64.0/20",
    "172.31.80.0/20",
  ]
}

variable "bastion_instance_type" {
  default = "t2.small"
}

//
// Outputs
//
output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_public_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "subnet_private_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "security_group_egress_id" {
  value = ["${aws_security_group.egress_public.id}"]
}

output "security_group_bastion_id" {
  value = ["${aws_security_group.bastion_ssh.id}"]
}

output "bastion_username" {
  value = "${module.images.os_user}"
}

output "bastion_ips_public" {
  value = ["${aws_instance.bastion.*.public_ip}"]
}
