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

  vpc_id                  = aws_vpc.bbte.id
  cidr_block              = each.value
  availability_zone_id    = each.key
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = join("-", [var.project_name, each.key])
    }, local.default_tags)

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bbte.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bbte.id
  }
  tags = merge(
    {
      Name = join("-", [var.project_name, "public"]),
    }, local.default_tags)
}

resource "aws_route_table_association" "bbtepublic" {
  for_each = aws_subnet.bbte

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}

resource "aws_internet_gateway" "bbte" {
  tags = merge(
    {
      Name = var.project_name
    }, local.default_tags)
}

resource "aws_internet_gateway_attachment" "bbte" {
  internet_gateway_id = aws_internet_gateway.bbte.id
  vpc_id              = aws_vpc.bbte.id
}
