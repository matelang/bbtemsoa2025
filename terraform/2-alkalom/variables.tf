variable "project_name" {
  type    = string
  default = "msoa"
}

variable "vpc_cidr" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "dns_parent_zone" {
  type = string
}