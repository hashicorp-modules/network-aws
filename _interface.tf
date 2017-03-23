variable "environment_name" {
  default = "vpc-foundation"
}

variable "os" {
  default = "rhel"
}

variable "example_instance_type" {
  default = "t2.micro"
}

variable "example_instance_count" {
  default = "1"
}

//
// Outputs
//
output "vpc_id" {
  value = "${module.network.vpc_id}"
}

output "subnet_public_ids" {
  value = ["${module.network.subnet_public_ids}"]
}

output "subnet_private_ids" {
  value = ["${module.network.subnet_private_ids}"]
}

output "bastion_username" {
  value = "${module.network.bastion_username}"
}

output "bastion_ips_public" {
  value = ["${module.network.bastion_ips_public}"]
}
