# Required variables
variable "environment_name" {
  description = "Environment Name"
}

variable "os" {
  # case sensitive for AMI lookup
  description = "Operating System to use ie RHEL or Ubuntu"
}

variable "os_version" {
  description = "Operating System version to use ie 7.3 (for RHEL) or 16.04 (for Ubuntu)"
}

variable "ssh_key_name" {
  description = "Pre-existing AWS key name you will use to access the instance(s)"
}

# Optional variables
variable "vpc_cidr" {
  default = "172.19.0.0/16"
}

variable "vpc_cidrs_public" {
  default = [
    "172.19.0.0/20",
    "172.19.16.0/20",
    "172.19.32.0/20",
  ]
}

variable "vpc_cidrs_private" {
  default = [
    "172.19.48.0/20",
    "172.19.64.0/20",
    "172.19.80.0/20",
  ]
}

variable "bastion_instance_type" {
  default = "t2.small"
}

# Outputs
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
  value = "${aws_security_group.egress_public.id}"
}

output "security_group_bastion_id" {
  value = "${aws_security_group.bastion_ssh.id}"
}

output "bastion_username" {
  value = "${module.images-aws.os_user}"
}

output "bastion_ips_public" {
  value = ["${aws_instance.bastion.*.public_ip}"]
}
