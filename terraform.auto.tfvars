region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

environment = "dev"

ami-web = "0ba86b9faaba8a277"

ami-bastion = "0449bbcbd43fcc82b"

ami-nginx = "0069a0a8575b684d1"

ami-sonar = "0529b4277d108c366"

keypair = "Micolo"

account_no = "945397719425"

master-username = "micahdb"

master-password = "devopstraining"

min_size = 2

max_size = 2

desired_capacity = 2

tags = {
  Owner-Email     = "micaho2000@gmail.com"
  Managed-by      = "Terraform"
  Billing-Account = "1234567890"
}
