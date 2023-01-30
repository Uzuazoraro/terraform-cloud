/*variable "ami-web" {
  type = string
  description = "ami for webservers"
}

variable "instance_profile" {
  type = string
  description = "instance profile for launch template"
}

variable "keypair" {
  type = string
  description = "keypair for instances"
}

variable "ami-bastion" {
  type = string
  description = "ami for bastion"
}

variable "ami-nginx" {
  type = string
  description = "ami for nginx"
}

variable "max_size" {
  type = number
  description = "maximun number of asg"
}

variable "min_size" {
  type = number
  description = "minimun number of asg"
}

variable "desired_capacity" {
  type = number
  description = "desired capacity of subnets"
}  

variable "public_subnets" {
  type = list(any)
  description = "list of public subnets"
}

variable "private_subnets" {
  type = list(any)
  description = "list of private subnets"
}  

variable "wordpress-alb-tgt" {
  type = string
  description = "wordpress application to internal loadbalancer"
}


variable "tooling-alb-tgt" {
  type = string
  description = "tooling application to internal loadbalancer"
}

variable "web-sg" {
  type = string
  description = "wordpress launch template"
}

variable "nginx-alb-tgt" {
  type = string
  description = "nginx application to external loadbalancer"
}

variable "bastion-sg" {
  type = string
  description = "bastion launch template"
}

variable "nginx-sg" {
  type = string
  description = "nginx launch template"
}

variable "tags" {
  description = "A mapping of tags to assign to all resuorces"
  type        = map(string)
  default     = {}
}*/