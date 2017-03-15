# network-aws

Creates a standard VPC with:
- Three public subnets
- Three private subnets
- One bastion host in each public subnet
- One NAT Gateway in each public subnet

## Requirements

The following environment variables must be set:

```
AWS_DEFAULT_REGION
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

## Usage

```
module "vpc" {
  source = "git@github.com:hashicorp-modules/network-aws.git//terraform"

  environment_name = "${var.environment_name}"
  os               = "${var.os}"
  ssh_key_name     = "${module.ssh_key.ssh_key_name}"
}
```
