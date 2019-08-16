resource "azurerm_template_deployment" "service_app_ssl_binding_main" {
  count               = "${var.count_of_app_services}"
  name                = "${format("%s-arm-ssl_binding", element(local.app_service_names, count.index))}"
  resource_group_name = "${var.resource_group_name}"
  deployment_mode     = "Incremental"

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "appServicesName":{
            "type": "string"
        },
        "FQDNs":{
            "type": "string"
        },
        "certificateThumbprint": {
            "type": "string"
        }
    },
    "variables":{
        "fqdns" :"[split(parameters('FQDNs'),',')]"
    },
    "resources": [
        {
            "condition":"[not(empty(parameters('certificateThumbprint')))]",
            "type":"Microsoft.Web/sites/hostnameBindings",
            "name":"[concat(parameters('appServicesName'), '/', variables('fqdns')[copyIndex('fqdnBindingCopy')])]",
            "apiVersion":"2016-03-01",
            "location":"[resourceGroup().location]",
            "properties":{
                "sslState":"SniEnabled",
                "thumbprint":"[parameters('certificateThumbprint')]"
            },
            "copy":{
                "name": "fqdnBindingCopy",
                "count": "[length(variables('fqdns'))]"
            },
            "dependsOn": []
        }
    ]
}
DEPLOY

  parameters = {
    "appServicesName"       = "${element(local.app_service_names, count.index)}"
    "FQDNs"                 = "${lookup(var.app_services_and_fqdns ,element(local.app_service_names, count.index))}"
    "certificateThumbprint" = "${var.certificate_thumbprint}"
  }

  depends_on = []
}
