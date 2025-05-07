locals {
  instance_names = formatlist("%s-%d", var.project_name, range(var.instance_count))
}

resource "aws_instance" "api" {
  for_each = toset(local.instance_names)

  ami           = "ami-0ecf75a98fe8519d7"
  instance_type = var.instance_type
  subnet_id     = var.vpc_subnet_ids[0]

  iam_instance_profile = aws_iam_instance_profile.api.name

  vpc_security_group_ids = [aws_security_group.api.id]

  tags = {
    Name = each.value,
  }
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
  vpc_id = var.vpc_id

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
