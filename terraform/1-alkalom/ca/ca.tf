# https://registry.terraform.io/providers/hashicorp/tls/latest/docs

terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

provider "tls" {}

resource "tls_private_key" "ca" {
  algorithm = "ECDSA"
}

resource "tls_self_signed_cert" "ca" {
  subject {
    common_name = "ca.bbte2025.com"
  }

  allowed_uses = [
    "cert_signing"
  ]

  private_key_pem       = tls_private_key.ca.private_key_pem
  validity_period_hours = 24 * 7
}

resource "local_file" "ca" {
  filename = "ca_cert.pem"
  content  = tls_self_signed_cert.ca.cert_pem
}
