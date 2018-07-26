variable "fqdns_count" {
  type = "string"
}

variable "webapp_kv_names_fqdns" {
  type = "map"

  description = <<eof
    "webapp01" = "webapp01.example.com"
    "webapp02" = "webapp02.example.com"
  eof
}

variable "resource_group_name" {
  description = "Azure Group Name"
  type        = "string"
}

variable "certificate_thumbprint" {
  description = "Certifcate Thumbprint"
  type        = "string"
}

locals {
  names = "${keys(var.webapp_kv_names_fqdns)}"
}
