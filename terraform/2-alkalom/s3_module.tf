module "s3" {
  source  = "cloudposse/s3-website/aws"
  version = "0.18.0"

  hostname = "app.bbte.matelang.dev"
  logs_enabled = false
  parent_zone_id = aws_route53_zone.bbte.id

  allow_ssl_requests_only = false
}

resource "aws_s3_object" "index" {
  bucket       = module.s3.s3_bucket_name
  key          = "index.html"
  content      = file("index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = module.s3.s3_bucket_name
  key          = "error.html"
  content      = file("error.html")
  content_type = "text/html"
}
