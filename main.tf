resource "azurerm_template_deployment" "service_app_ssl_binding_main" {
  count               = "${var.application_type_count}"
  name                = "${format("%s-arm-ssl_binding", element(local.names, count.index))}"
  resource_group_name = "${var.resource_group_name}"
  deployment_mode     = "Incremental"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "webappName":{
            "type": "string"
        },
        "customFQDN":{
            "type": "string"
        },
        "certificateThumbprint": {
            "type": "string"
        }
    },
    "variables":{},
    "resources": [
        {
            "condition":"[not(empty(parameters('certificateThumbprint')))]",
            "type":"Microsoft.Web/sites/hostnameBindings",
            "name":"[concat(parameters('webappName'), '/', parameters('customFQDN'))]",
            "apiVersion":"2016-03-01",
            "location":"[resourceGroup().location]",
            "properties":{
                "sslState":"SniEnabled",
                "thumbprint":"[parameters('certificateThumbprint')]"
            },
            "dependsOn": []
        }
    ]
}
DEPLOY

  parameters {
    "webappName"            = "${element(local.names, count.index)}"
    "customFQDN"            = "${lookup(var.webapp_kv_names_fqdns ,element(local.names, count.index))}"
    "certificateThumbprint" = "${var.certificate_thumbprint}"
  }

  depends_on = []
}
