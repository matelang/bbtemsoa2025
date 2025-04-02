// Komment egysoros

# Egysoros

/*
Tobbsoros
Masik
Harmadik
 */

# https://developer.hashicorp.com/terraform/language/functions/

variable "x" {
  type = string
}

output "x" {
  value = var.x
}

variable "num" {
  type = number
}

output "szam" {
  value = var.num
}

locals {
  szam_sring_bbte = format("bbte-%d", var.num)
  joined_sequence = join("-", var.sequence)
}

output "szam_string" {
  value = format("%d", var.num)
}

output "szam_string_bbte" {
  value = local.szam_sring_bbte
}

variable "sequence" {
  type = list(number)
  description = "Ez egy lista"
  default = [1, 2, 3, 4, 5]
}

variable "fura_lista" {
  type = list(string)
  default = ["", "", "a", ""]
}

output "sequence" {
  value = var.sequence
}

output "sequence_str" {
  value = formatlist("bbte-%d", var.sequence)
}

output "trimmed_prefix_bbte" {
  value = tonumber(trimprefix(local.szam_sring_bbte, "bbte-"))
}

output "joined_sequence" {
  value = local.joined_sequence
}

output "coal_fura_lista" {
  value = coalesce(var.fura_lista...)
}

variable "egymap" {
  type = map(string)

  default = {
    a = "b"
    c = "d"
  }
}

output "mapkeys" {
  value = keys(var.egymap)
}

output "mapvalues" {
  value = values(var.egymap)
}

locals {
  # https://developer.hashicorp.com/terraform/language/expressions/for

  forexppelda        = {for key, value in var.egymap : key => join("-", [key, value])}
  forexppelda_invert = {for key, value in var.egymap : value => key}
}

output "forexxpelda" {
  value = local.forexppelda
}

output "forexxpelda_invert" {
  value = local.forexppelda_invert
}

output "b64" {
  value = base64encode(local.joined_sequence)
}

output "jsonexample" {
  value = jsonencode(
    {
      "hello" = "world"
    }
  )
}

locals {
  ip_range = "10.0.0.0/16"
}

output "ipsubnet1" {
  value = cidrsubnet(local.ip_range, 8, 1)
}

output "ipsubnet2" {
  value = cidrsubnet(local.ip_range, 8, 2)
}

