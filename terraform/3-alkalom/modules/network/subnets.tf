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

  tags = {
    Name = join("-", [var.project_name, each.key])
  }

}

resource "aws_route_table_association" "bbtepublic" {
  for_each = aws_subnet.bbte

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value.id
}
