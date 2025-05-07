variable "env" {
  type    = string
  default = "dev"
}

locals {
  derived_project_name = join("-", ["msoa", var.env])
}

module "network" {
  source = "./modules/network"

  vpc_cidr        = "10.0.0.0/16"
  dns_parent_zone = "matelang.dev"
  project_name    = local.derived_project_name
}

module "backend" {
  source = "./modules/backend"

  project_name = local.derived_project_name

  vpc_id               = module.network.vpc_id
  vpc_subnet_ids       = module.network.vpc_subnet_ids
  lb_arn               = module.network.lb_arn
  lb_security_group_id = module.network.lb_security_group_id
}

module "frontend" {
  source = "./modules/frontend"
}
