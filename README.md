# AWS Network Terraform Module

Creates a standard network in AWS that includes:

- One VPC
- Three public subnets
- Three private subnets
- One NAT Gateway in each public subnet
- One bastion host in each public subnet with Consul, Vault, and Nomad agents installed

This module requires a pre-existing AWS SSH key pair for each bastion host.

## Environment Variables

- `AWS_DEFAULT_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Input Variables

- `create`: [Optional] Create Module, defaults to true.
- `name`: [Optional] Name for resources, defaults to "network-aws".
- `create_vpc`: [Optional] Determines whether a VPC should be created or if a VPC ID will be passed in.
- `vpc_id`: [Optional] VPC ID to override, must be entered if "create_vpc" is false.
- `vpc_cidr`: [Optional] VPC CIDR block, defaults to 10.139.0.0/16.
- `vpc_cidrs_public`: [Optional] VPC CIDR blocks for public subnets, defaults to "10.139.1.0/24", "10.139.2.0/24", and "10.139.3.0/24".
- `nat_count`: [Optional] Number of NAT gateways to provision across public subnets, defaults to public subnet count.
- `vpc_cidrs_private`: [Optional] VPC CIDR blocks for private subnets, defaults to "10.139.11.0/24", "10.139.12.0/24", and "10.139.13.0/24".
- `ami_owner`: [Optional] Account ID of AMI owner.
- `release_version`: [Optional] Release version tag to use (e.g. 0.1.0, 0.1.0-rc1, 0.1.0-beta1, 0.1.0-dev1), defaults to "0.1.0", view releases at https://github.com/hashicorp/guides-configuration#hashistack-version-tables.
- `consul_version`: [Optional] Consul version tag to use (e.g. 1.2.3 or 1.2.3-ent), defaults to "1.2.3".
- `vault_version`: [Optional] Vault version tag to use (e.g. 0.11.3 or 0.11.3-ent), defaults to "0.11.3".
- `nomad_version`: [Optional] Nomad version tag to use (e.g. 0.8.6 or 0.8.6-ent), defaults to "0.8.6".
- `os`: [Optional] Operating System to use (e.g. RHEL or Ubuntu), defaults to "RHEL".
- `os_version`: [Optional] Operating System version to use (e.g. 7.3 for RHEL or 16.04 for Ubuntu), defaults to "7.3".
- `bastion_count`: [Optional] Number of bastion hosts to provision across public subnets, defaults to public subnet count.
- `image_id`: [Optional] AMI to use, defaults to the HashiStack AMI.
- `instance_profile`: [Optional] AWS instance profile to use, defaults to consul-auto-join-instance-role module.
- `instance_type`: [Optional] AWS instance type of the bastion host (e.g. m4.large), defaults to "t2.small".
- `user_data`: [Optional] user_data script to pass in at runtime.
- `ssh_key_name`: [Optional] AWS key name you will use to access the Bastion host instance(s), defaults to generating an SSH key for you.
- `private_key_file`: [Optional] Private key filename for AWS key passed in, defaults to empty.
- `ssh_key_override`: [Optional] Override the default SSH key and pass in your own, defaults to false.
- `user`: [Optional] Map of SSH users.
- `tags`: [Optional] Optional map of tags to set on resources, defaults to empty map.

## Outputs

- `zREADME`: The module README.
- `vpc_cidr`: The VPC CIDR block.
- `vpc_id`: The VPC ID.
- `subnet_public_ids`: The public subnet IDs.
- `subnet_private_ids`: The private subnet IDs.
- `bastion_security_group`: The ID of the bastion host security group.
- `bastion_ips_public`: The public IP(s) of the Bastion host(s).
- `bastion_username`: The Bastion host username.
- `private_key_name`: The private key name.
- `private_key_filename`: The private key filename.
- `private_key_pem`: The private key data in PEM format.
- `public_key_pem`: The public key data in PEM format.
- `public_key_openssh`: The public key data in OpenSSH authorized_keys format, if the selected private key format is compatible. All RSA keys are supported, and ECDSA keys with curves "P256", "P384" and "P251" are supported. This attribute is empty if an incompatible ECDSA curve is selected.
- `ssh_key_name`: Name of AWS keypair.

## Submodules

- [AWS Consul Auto Join Instance Role Terraform Module](https://github.com/hashicorp-modules/consul-auto-join-instance-role)
- [AWS Consul Client Ports Terraform Module](https://github.com/hashicorp-modules/consul-client-ports-aws)

## Recommended Modules

These are recommended modules you can use to populate required input variables for this module. The sub-bullets show the mapping of output variable --> required input variable for the respective modules.

- [AWS SSH Keypair Terraform Module](https://github.com/hashicorp-modules/ssh-keypair-aws)
  - `ssh_key_name` --> `ssh_key_name`
- [AWS Network Terraform Module](https://github.com/hashicorp-modules/network-aws/)
  - `vpc_cidr` --> `vpc_cidr`
  - `vpc_id` --> `vpc_id`
  - `subnet_private_ids` --> `subnet_ids`

## Authors

HashiCorp Solutions Engineering Team.

## License

Mozilla Public License Version 2.0. See LICENSE for full details.
