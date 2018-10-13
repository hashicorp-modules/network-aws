variable "create" {
  description = "Create Module, defaults to true."
  default     = true
}

variable "name" {
  description = "Name for resources, defaults to \"network-aws\"."
  default     = "network-aws"
}

variable "create_vpc" {
  description = "Determines whether a VPC should be created or if a VPC ID will be passed in."
  default     = true
}

variable "vpc_id" {
  description = "VPC ID to override, must be entered if \"create_vpc\" is false."
  default     = ""
}

variable "vpc_cidr" {
  description = "VPC CIDR block, defaults to \"10.139.0.0/16\"."
  default     = "10.139.0.0/16"
}

variable "vpc_cidrs_public" {
  description = "VPC CIDR blocks for public subnets, defaults to \"10.139.1.0/24\", \"10.139.2.0/24\", and \"10.139.3.0/24\"."
  type        = "list"
  default     = ["10.139.1.0/24", "10.139.2.0/24", "10.139.3.0/24",]
}

variable "nat_count" {
  description = "Number of NAT gateways to provision across public subnets, defaults to public subnet count."
  default     = -1
}

variable "vpc_cidrs_private" {
  description = "VPC CIDR blocks for private subnets, defaults to \"10.139.11.0/24\", \"10.139.12.0/24\", and \"10.139.13.0/24\"."
  type        = "list"
  default     = ["10.139.11.0/24", "10.139.12.0/24", "10.139.13.0/24",]
}

variable "ami_owner" {
  description = "Account ID of AMI owner."
  default     = "012230895537" # HashiCorp Public AMI AWS account
}

variable "release_version" {
  description = "Release version tag (e.g. 0.1.0, 0.1.0-rc1, 0.1.0-beta1, 0.1.0-dev1), defaults to \"0.1.0\", view releases at https://github.com/hashicorp/guides-configuration#hashistack-version-tables"
  default     = "0.1.0"
}

variable "consul_version" {
  description = "Consul version tag (e.g. 1.2.3 or 1.2.3-ent), defaults to \"1.2.3\"."
  default     = "1.2.3"
}

variable "vault_version" {
  description = "Vault version tag (e.g. 0.11.3 or 0.11.3-ent), defaults to \"0.11.3\"."
  default     = "0.11.3"
}

variable "nomad_version" {
  description = "Nomad version tag (e.g. 0.8.6 or 0.8.6-ent), defaults to \"0.8.6\"."
  default     = "0.8.6"
}

variable "os" {
  description = "Operating System (e.g. RHEL or Ubuntu), defaults to \"RHEL\"."
  default     = "RHEL"
}

variable "os_version" {
  description = "Operating System version (e.g. 7.3 for RHEL or 16.04 for Ubuntu), defaults to \"7.3\"."
  default     = "7.3"
}

variable "bastion_count" {
  description = "Number of bastion hosts to provision across public subnets, defaults to public subnet count."
  default     = -1
}

variable "image_id" {
  description = "AMI to use, defaults to the HashiStack AMI."
  default     = ""
}

variable "instance_profile" {
  description = "AWS instance profile to use, defaults to consul-auto-join-instance-role module."
  default     = ""
}

variable "instance_type" {
  description = "AWS instance type for bastion host (e.g. m4.large), defaults to \"t2.small\"."
  default     = "t2.small"
}

variable "user_data" {
  description = "user_data script to pass in at runtime."
  default     = ""
}

variable "ssh_key_name" {
  description = "AWS key name you will use to access the Bastion host instance(s), defaults to generating an SSH key for you."
  default     = ""
}

variable "private_key_file" {
  description = "Private key filename for AWS key passed in, defaults to empty."
  default     = ""
}

variable "ssh_key_override" {
  description = "Override the default SSH key and pass in your own, defaults to false."
  default     = false
}

variable "users" {
  description = "Map of SSH users."

  default = {
    RHEL   = "ec2-user"
    Ubuntu = "ubuntu"
  }
}

variable "tags" {
  description = "Optional map of tags to set on resources, defaults to empty map."
  type        = "map"
  default     = {}
}
