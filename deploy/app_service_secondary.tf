resource "azurerm_app_service_plan" "unemployment_secondary" {
  count               = var.environment == "prod" ? 1 : 0
  name                = "${var.dns_prefix}-unemployment-plan-${var.environment}-${var.location_secondary_code}"
  location            = var.location_secondary
  resource_group_name = data.azurerm_resource_group.default.name
  kind                = "Linux"

  # Reserved must be set to true for Linux App Service Plans
  reserved = true

  sku {
    tier = var.plan_tier
    size = var.plan_sku
  }
}

resource "azurerm_app_service" "unemployment_secondary" {
  count               = var.environment == "prod" ? 1 : 0
  name                = "${var.dns_prefix}-unemployment-${var.environment}-${var.location_secondary_code}"
  location            = var.location_secondary
  resource_group_name = data.azurerm_resource_group.default.name
  app_service_plan_id = azurerm_app_service_plan.unemployment_secondary[0].id
  https_only          = true
  client_cert_enabled = true

  site_config {
    always_on        = true
    linux_fx_version = "NODE|12-lts"
    app_command_line = "npm run start:prod"
    ftps_state       = "Disabled"
  }

  identity {
    type = "SystemAssigned"
  }

  provisioner "local-exec" {
    command = "az resource update --name ${var.dns_prefix}-unemployment-${var.environment}-${var.location_secondary_code} --resource-group ${data.azurerm_resource_group.default.name} --namespace Microsoft.Web --resource-type sites --set properties.clientCertMode=Optional"
  }
}