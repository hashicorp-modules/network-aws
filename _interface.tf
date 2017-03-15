variable "environment_name" {
  default = "vpc-foundation"
}

variable "os" {
  default = "ubuntu"
}

//
// Outputs
//
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "subnet_public_ids" {
  value = ["${module.vpc.subnet_public_ids}"]
}

output "subnet_private_ids" {
  value = ["${module.vpc.subnet_private_ids}"]
}

output "bastion_username" {
  value = "${module.vpc.bastion_username}"
}

output "bastion_ips_public" {
  value = ["${module.vpc.bastion_ips_public}"]
}
