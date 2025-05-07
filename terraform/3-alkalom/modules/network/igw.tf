resource "aws_internet_gateway" "bbte" {
  tags = {
    Name = var.project_name
  }
}

resource "aws_internet_gateway_attachment" "bbte" {
  internet_gateway_id = aws_internet_gateway.bbte.id
  vpc_id              = aws_vpc.bbte.id
}
