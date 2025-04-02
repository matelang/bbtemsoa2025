resource "tls_private_key" "applicant" {
  algorithm = "ECDSA"
}

resource "tls_cert_request" "applicant" {
  private_key_pem = tls_private_key.applicant.private_key_pem

  subject {
    common_name = "applicant.bbte2025.com"
  }
}

resource "tls_locally_signed_cert" "applicant" {
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  ca_cert_pem           = tls_self_signed_cert.ca.cert_pem
  ca_private_key_pem    = tls_private_key.ca.private_key_pem
  cert_request_pem      = tls_cert_request.applicant.cert_request_pem
  validity_period_hours = 24 * 3
}

resource "local_file" "applicant" {
  filename = "applicant_cert.pem"
  content  = tls_locally_signed_cert.applicant.cert_pem
}
