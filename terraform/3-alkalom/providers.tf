provider "aws" {
  profile = "bbte2025"
  region  = "eu-central-1"

  default_tags {
    tags = { Maintainer = "BBTE" }
  }
}
