variable "count_of_app_services" {}

variable "app_services_and_fqdns" {
  type = "map"

  description = <<eof
    "webapp01" = "webapp01.example.com,spacialName.example.com"]
    "webapp02" = "webapp02.example.com"
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
  app_service_names = "${keys(var.app_services_and_fqdns)}"
}
