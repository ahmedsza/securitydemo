resource "azurerm_app_service_plan" "unemployment" {
  name                = "${var.dns_prefix}-unemployment-plan-${var.environment}-${var.location_code}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.default.name
  kind                = "Linux"

  # Reserved must be set to true for Linux App Service Plans
  reserved = true

  sku {
    tier = var.plan_tier
    size = var.plan_sku
  }
}

resource "azurerm_app_service" "unemployment" {
  name                = "${var.dns_prefix}-unemployment-${var.environment}-${var.location_code}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.default.name
  app_service_plan_id = azurerm_app_service_plan.unemployment.id
  https_only          = true
  client_cert_enabled = true

  site_config {
    always_on        = true
    linux_fx_version = "NODE|12-lts"
    app_command_line = "npm run start:prod"
    ftps_state       = "Disabled"
  }

  app_settings = {
    "AZURE_STORAGE_CONNECTION_STRING": "@Microsoft.KeyVault(VaultName=${var.dns_prefix}${var.environment}kv;SecretName=storageAccountKey)"
  }

  identity {
    type = "SystemAssigned"
  }

  provisioner "local-exec" {
    command = "az resource update --name ${var.dns_prefix}-unemployment-${var.environment}-${var.location_code} --resource-group ${data.azurerm_resource_group.default.name} --namespace Microsoft.Web --resource-type sites --set properties.clientCertMode=Optional"
  }
}
