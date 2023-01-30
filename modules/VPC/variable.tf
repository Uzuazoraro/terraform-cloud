/*variable "region" {
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

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "name" {
  type = string
  description = "names of various concepts"
}

variable "environment" {
  default = "true"
}
*/