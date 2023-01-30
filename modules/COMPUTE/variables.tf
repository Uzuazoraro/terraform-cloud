variable "sg-compute" {
  type = string
  description = "security group for the file system"
}

variable "ami-jenkins" {
    type = string
    description = "for jenkins instance"
}

variable "ami-sonar" {
    type = string
    description = "for sonarqube instance"
}

variable "ami-jfrog" {
    type = string
    description = "for artifactory instance"
}

variable "subnets-compute" {
  type = list(any)
  description = "list of compute subnet"
}

variable "keypair" {
  type        = string
  description = "keypair for the instances"
}  

variable "tags" {
  description = "A mapping of tags to assign to all resuorces"
  type        = map(string)
  default = {}
}