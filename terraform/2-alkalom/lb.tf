resource "aws_lb" "bbte" {
  name = join("-", [var.project_name, "alb"])
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.lb.id]
  subnets            = [for subnet in aws_subnet.bbte : subnet.id]

  enable_deletion_protection = false

  tags = merge(
    {
      Name = var.project_name
    }, local.default_tags)

}

resource "aws_security_group" "lb" {
  name   = "lb"
  vpc_id = aws_vpc.bbte.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [aws_security_group.api.id]
  }
}

resource "aws_lb_listener" "bbte" {
  load_balancer_arn = aws_lb.bbte.arn

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
  vpc_id   = aws_vpc.bbte.id

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
  for_each = toset([for instance in aws_instance.api : instance.id])

  target_group_arn = aws_lb_target_group.api.arn
  target_id        = each.value
  port             = 80
}
