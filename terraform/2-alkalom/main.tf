provider "aws" {
  profile = "bbte2025"
  region  = "eu-central-1"
}

resource "aws_instance" "api" {
  ami           = "ami-0ecf75a98fe8519d7"
  instance_type = var.instance_type
  subnet_id     = aws_subnet.bbte[keys(local.derived_subnet_cidrs).0].id

  iam_instance_profile = aws_iam_instance_profile.api.name

  vpc_security_group_ids = [aws_security_group.api.id]

  tags = merge(
    {
      Name = join("-", [var.project_name, "api"])
    }, local.default_tags)

}

resource "aws_iam_instance_profile" "api" {
  name = "api"
  role = aws_iam_role.api.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "api" {
  name               = "api"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.api.name
}

resource "aws_security_group" "api" {
  name   = "api"
  vpc_id = aws_vpc.bbte.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

### Trivialis megkozelites, duplikalt kod
# resource "aws_subnet" "bbte1" {
#   vpc_id               = aws_vpc.bbte.id
#   cidr_block = "10.0.1.0/24" # 10.0.1.0-10.0.1.255
#   availability_zone_id = data.aws_availability_zones.available.zone_ids.0
#
#   tags = merge(
#     {
#       Name = join("-", [var.project_name, data.aws_availability_zones.available.zone_ids.0])
#     }, local.default_tags)
#
# }
#
# resource "aws_subnet" "bbte2" {
#   vpc_id               = aws_vpc.bbte.id
#   cidr_block = "10.0.2.0/24" # 10.0.2.0-10.0.2.255
#   availability_zone_id = data.aws_availability_zones.available.zone_ids.1
#
#   tags = merge(
#     {
#       Name = join("-", [var.project_name, data.aws_availability_zones.available.zone_ids.1])
#     }, local.default_tags)
#
# }
