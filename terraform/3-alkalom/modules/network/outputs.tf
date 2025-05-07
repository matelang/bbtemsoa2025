output "vpc_id" {
  value = aws_vpc.bbte.id
}

output "vpc_subnet_ids" {
  value = [for subnet in aws_subnet.bbte : subnet.id]
}

output "lb_arn" {
  value = aws_lb.bbte.arn
}

output "lb_security_group_id" {
  value = aws_security_group.lb.id
}
