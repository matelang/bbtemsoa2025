resource "aws_route53_zone" "bbte" {
  name = join(".", ["bbte", var.dns_parent_zone])
}
