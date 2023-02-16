# Creating bucket for s3 backend

resource "aws_s3_bucket" "terraform_state" {
  bucket = "micolo-dev-terraform-bucket"

  # Enable versioning so we can see the full revision history of our state files
  versioning {
    enabled = true
  }
  force_destroy = true

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# create a DynamoDB table to handle locks and perform consistency checks.
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

# private subnets in range(1, 8, 2) means subnets should be odd numbers by adding 2 to the numbers btw 1 & 8. ie 1+2=3, 3+2=5, 5+2=7. So the private subnets are 1,3,5,7.   
# creating VPC

modules "VPC" {
  source                              = "./modules/VPC"
  name                                = var.name
  environment                         = var.environment
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  enable_classiclink                  = var.enable_classiclink
  enable_classiclink_dns_support      = var.enable_dns_support
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  private_subnets                     = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets                      = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}

# Module for Application Load Balancer. This will create External and Internal Ll;oad Balancer.

module "ALB" {
  source                 = "./modules/ALB"
  name                   = var.name
  vpc_id                 = module.VPC.vpc_id
  public-sg              = module.security.ALB-sg
  private-sg             = module.security.IALB-sg
  public-sbn-1           = module.VPC.public_subnets-1
  public-sbn-2           = module.VPC.public_subnets-2
  private-sbn-1          = module.VPC.private_subnets-1
  private-sbn-2          = module.VPC.private_subnets-2
  lb_interval            = 10
  tgt_protocol           = "HTTPS"
  lb_timeout             = 5
  lb_healthy_threshold   = 5
  lb_unhealthy_threshold = 2
  tgt_port               = 443
  tgt_target_type        = "Instance"
  listener_port          = 443
  listener_protocol      = "HTTPS"

  load_balancer_type = "application"
  ip_address_type    = "ipv4"
}

module "security" {
  source    = "./modules/security"
  vpc_id    = module.VPC.vpc_id
  access_ip = var.access_ip
  for_each  = var.security_groups
}

module "Autoscaling" {
  source            = "./modules/Autoscaling"
  ami-web           = var.ami-web
  ami-bastion       = var.ami-bastion
  ami-nginx         = var.ami-nginx
  desired_capacity  = var.desired_capacity
  min_size          = var.min_size
  max_size          = var.max_size
  web-sg            = [module.security.web-sg]
  bastion-sg        = [module.security.bastion-sg]
  nginx-sg          = [module.security.nginx-sg]
  wordpress-alb-tgt = module.ALB.wordpress-tgt
  nginx-alb-tgt     = module.ALB.nginx-tgt
  tooling-alb-tgt   = module.ALB.tooling-tgt
  instance_profile  = module.VPC.instance_profile
  public_subnets    = [module.VPC.public_subnets-1, module.VPC.public_subnets-2]
  private_subnets   = [module.VPC.private_subnets-1, module.VPC.private_subnets-2]
  keypair           = var.keypair
}

# Module for Elastic Filesystem; this module will create elastic file system in the webservers availability
# zone and allow traffic from the webservers. 

module "EFS" {
  source       = "./modules/EFS"
  efs-subnet-1 = module.VPC.private_subnets-1
  efs-subnet-2 = module.VPC.private_subnets-2
  efs-sg       = [module.security.datalayer-sg]
  account_no   = var.account_no
}

# RDS module: this module will create RDS instance in the private subnet

module "RDS" {
  source          = "./modules/RDS"
  dbname          = var.dbname
  master-username = var.master-username
  master-password = var.master-password
  db-sg           = [module.security.datalayer-sg]
  private_subnets = [module.VPC.private_subnets-3, module.VPC.private_subnets-4]
  #private_subnets = module.VPC.private_subnets.*.id
}

# This module creates instances for Jenkins, Sonarqube and Jfrog
module "compute" {
  source          = "./modules/Compute"
  ami-jenkins     = var.ami-bastion
  ami-sonar       = var.ami-sonar
  ami-jfrog       = var.ami-bastion
  ami-nginx       = var.ami-nginx
  subnets-compute = module.VPC.public_subnets-1
  sg-compute      = [module.security.compute-sg]
  keypair         = var.keypair
}
