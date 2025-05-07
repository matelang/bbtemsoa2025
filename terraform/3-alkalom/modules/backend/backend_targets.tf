terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_lb_listener" "bbte" {
  load_balancer_arn = var.lb_arn

  port     = "80"
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.arn
  }
}

resource "aws_lb_target_group" "api" {
  name = join("-", [var.project_name, "api"])
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "bbte" {
  for_each = toset(local.instance_names)

  target_group_arn = aws_lb_target_group.api.arn
  target_id        = aws_instance.api[each.value].id
  port             = 80
}

resource "aws_vpc_security_group_egress_rule" "lbegress" {
  ip_protocol = "tcp"

  security_group_id = var.lb_security_group_id
  from_port         = 80
  to_port           = 80

  referenced_security_group_id = aws_security_group.api.id
}
