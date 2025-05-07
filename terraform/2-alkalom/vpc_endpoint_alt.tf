### VPC ENDPOINT ALTERNATIVE BELOW
# locals {
#   # s3
#   vpc_endpoints_set = toset(["ssm", "ec2messages", "ec2", "ssmmessages", "kms", "logs"])
#
#   subnet_endpoint_tuples = flatten([
#     for subnet in aws_subnet.bbte : [
#       for endpoint in local.vpc_endpoints_set : {
#         s = subnet.id
#         e = aws_vpc_endpoint.endpoints[endpoint].id
#       }
#     ]
#   ])
# }

#
# resource "aws_vpc_endpoint" "endpoints" {
#   for_each = local.vpc_endpoints_set
#
#   vpc_id = aws_vpc.bbte.id
#   service_name = join(".", [
#     "com.amazonaws", data.aws_region.current.name, each.value
#   ])
#   vpc_endpoint_type = "Interface"
#
#   private_dns_enabled = true
# }
#
# resource "aws_vpc_endpoint_subnet_association" "endpoints" {
#   for_each = {for v in local.subnet_endpoint_tuples : join("_", [v["s"], v["e"]]) => v}
#
#   subnet_id       = each.value["s"]
#   vpc_endpoint_id = each.value["e"]
# }
