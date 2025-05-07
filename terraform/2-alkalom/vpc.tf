resource "aws_vpc" "bbte" {
  cidr_block = var.vpc_cidr

  assign_generated_ipv6_cidr_block = false

  tags = merge(
    {
      Name = var.project_name
    }, local.default_tags)

  enable_dns_hostnames = true
  enable_dns_support   = true

}

locals {
  derived_subnet_cidrs = {
    for az in data.aws_availability_zones.available.zone_ids :
    az => cidrsubnet(aws_vpc.bbte.cidr_block, 8, index(data.aws_availability_zones.available.zone_ids, az) + 1)
  }
}

resource "aws_subnet" "bbte" {
  for_each = local.derived_subnet_cidrs

  vpc_id               = aws_vpc.bbte.id
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = merge(
    {
      Name = join("-", [var.project_name, each.key])
    }, local.default_tags)

}

