variable "vpc_id" {
    type = string
    description = "the vpc_id"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default = {}
}

variable "access_ip" {
  description = "ip access for the various aws_security_group_rule"
}