variable "project_name" {
  type    = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
}

variable "vpc_subnet_ids" {
  type = list(string)
}

variable "lb_arn" {
  type = string
}

variable "lb_security_group_id" {
  type = string
}

variable "instance_count" {
  type = number
  default = 2
}