resource "aws_vpc" "bbte" {
  cidr_block = var.vpc_cidr

  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = var.project_name
  }

  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bbte.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bbte.id
  }
  tags = {
    Name = join("-", [var.project_name, "public"]),
  }
}
