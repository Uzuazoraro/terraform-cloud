variable "region" {
    type = string
}

variable "vpc_cidr" {
  type = string
}

variable "enable_dns_support" {
  type = bool 
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_classiclink" {
  type = bool
}

variable "enable_classiclink_dns_support" {
  type = bool
}

variable "preferred_number_of_public_subnets" {
  type        = number
  description = "number of public subnets"
}

variable "preferred_number_of_private_subnets" {
  type        = number
  description = "number of private subnets"
}

variable "private_subnets" {
  type = list
  description = "list of private subnets"
}


variable "public_subnets" {
  type = list
  description = "list of public subnets"
}

variable "dbname" {
    type = string
}

variable "master-username" {
    type = string
    description = "RDS master-username"
}

variable "master-password" {
    type = string
    description = "RDS master-password"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "keypair" {
  type = string
  description = "keypair for the instances"
}

variable "name" {
  type = string
  description = "names of various concepts"
}

variable "environment" {
  default = "true"
}

variable "desired_capacity" {}

variable "min_size" {}

variable "max_size" {}

variable "compute-sg" {}

variable "ami-jenkins" {}

variable "ami-sonar" {}

variable "ami-jfrog" {}

variable "subnets-compute" {}