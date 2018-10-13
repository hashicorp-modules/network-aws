create            = true
name              = "network-aws-advanced"
create_vpc        = false
rsa_bits          = "3072"
vpc_cidr          = "172.19.0.0/16"
vpc_cidrs_public  = ["172.19.0.0/20", "172.19.16.0/20", "172.19.32.0/20",]
nat_count         = "1" # Number of NAT gateways to provision across public subnets, defaults to public subnet count.
vpc_cidrs_private = ["172.19.48.0/20", "172.19.64.0/20", "172.19.80.0/20",]
release_version   = "0.1.0" # Release version tag (e.g. 0.1.0, 0.1.0-rc1, 0.1.0-beta1, 0.1.0-dev1)
consul_version    = "1.2.3" # Consul version tag (e.g. 1.2.3 or 1.2.3-ent) - https://releases.hashicorp.com/consul/
vault_version     = "0.11.3" # Vault version tag (e.g. 0.11.3 or 0.11.3-ent) - https://releases.hashicorp.com/vault/
nomad_version     = "0.8.6" # Nomad version tag (e.g. 0.8.6 or 0.8.6-ent) - https://releases.hashicorp.com/nomad/
os                = "Ubuntu" # OS (e.g. RHEL, Ubuntu)
os_version        = "16.04" # OS Version (e.g. 7.3 for RHEL, 16.04 for Ubuntu)
bastion_count     = "1" # Number of bastion hosts to provision across public subnets, defaults to public subnet count.
instance_type     = "t2.small"
tags              = { "foo" = "bar", "fizz" = "buzz" }
