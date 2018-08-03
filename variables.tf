variable "service_apps_count" {}

variable "service_apps_and_fqdns" {
  type = "map"

  description = <<eof
    "webapp01" = ["webapp01.example.com","spacialName.example.com"]
    "webapp02" = ["webapp02.example.com"]
  eof
}

variable "certificate_thumbprint" {
  description = "Certifcate Thumbprint"
  type        = "string"
}

variable "resource_group_name" {
  description = "Azure Group Name"
  type        = "string"
}

locals {
  mapped_names = "${keys(var.service_apps_and_fqdns)}"
}
