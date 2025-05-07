terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_lb" "bbte" {
  name = join("-", [var.project_name, "alb"])
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb.id]
  subnets            = [for subnet in aws_subnet.bbte : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = var.project_name
  }

}

resource "aws_security_group" "lb" {
  name   = "lb"
  vpc_id = aws_vpc.bbte.id
}

resource "aws_vpc_security_group_ingress_rule" "lbingress_all" {
  security_group_id = aws_security_group.lb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}
