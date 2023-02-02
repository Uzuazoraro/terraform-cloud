
variable "db-sg" {
    type = list
    description = "The DB security group"
}

variable "private_subnets" {
    type = list(any)
    description = "private subnets for DB subnets group"
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
    description = "A mapping of tags to assign to all resources"
    type = map(string)
    default = {}
}