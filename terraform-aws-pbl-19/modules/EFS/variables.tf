variable "efs-sg" {
  type        = list(any)
  description = "security group for the file system"
}

variable "efs-subnet-1" {
    description = "first subnet for the mount target"
}

variable "efs-subnet-2" {
    description = "second subnet for the mount target"
}

variable "tags" {
  description = "A mapping of tags to assign to all resuorces"
  type        = map(string)
  default = {}
}