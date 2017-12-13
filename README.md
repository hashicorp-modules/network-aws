# network-aws

Creates a standard VPC with:
- Three public subnets
- Three private subnets
- One bastion host in each public subnet
- One NAT Gateway in each public subnet

## Requirements

This module requires a pre-existing AWS key pair to install on each bastion host.

### Environment Variables

- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### Terraform Variables

You can pass the following Terraform variables during `terraform apply` or
in a `terraform.tfvars` file. Examples below:

- `environment_name` = "network-test"
- `os` = "rhel"
- `os_version` = "7.3"
- `ssh_key_name` = "test_aws"

## Outputs

- `vpc_id`
- `subnet_public_ids`
- `subnet_private_ids`
- `security_group_egress_id`
- `security_group_bastion_id`
- `bastion_username`
- `bastion_ips_public`

## Usage

```
variable "environment_name" {
  default = "network-test"
  description = "Environment Name"
}

variable "os" {
  # case sensitive for AMI lookup
  default = "RHEL"
  description = "Operating System to use ie RHEL or Ubuntu"
}

variable "os_version" {
  default = "7.3"
  description = "Operating System version to use ie 7.3 (for RHEL) or 16.04 (for Ubuntu)"
}

variable "ssh_key_name" {
  default = "test_aws"
  description = "Pre-existing AWS key name you will use to access the instance(s)"
}

module "network-aws" {
  source           = "git@github.com:hashicorp-modules/network-aws.git"
  environment_name = "${var.environment_name}"
  os               = "${var.os}"
  os_version       = "${var.os_version}"
  ssh_key_name     = "${module.ssh-keypair-aws.ssh_key_name}"
}
```
