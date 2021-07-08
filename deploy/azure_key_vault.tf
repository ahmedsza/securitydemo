data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.dns_prefix}${var.environment}kv"
  location                    = var.location
  resource_group_name         = data.azurerm_resource_group.default.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}

resource "azurerm_key_vault_access_policy" "current" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get"
  ]

  secret_permissions = [
    "Get",
    "Set",
    "Delete"
  ]
}

resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = azurerm_app_service.unemployment.identity[0].tenant_id
  object_id    = azurerm_app_service.unemployment.identity[0].principal_id

  key_permissions = [
    "Get"
  ]

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_key_vault_access_policy" "appsecondary" {
  count        = var.environment == "prod" ? 1 : 0
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = azurerm_app_service.unemployment_secondary[0].identity[0].tenant_id
  object_id    = azurerm_app_service.unemployment_secondary[0].identity[0].principal_id

  key_permissions = [
    "Get"
  ]

  secret_permissions = [
    "Get"
  ]
}

resource "azurerm_key_vault_secret" "storage" {
  name         = "storageAccountKey"
  value        = azurerm_storage_account.unemployment.primary_connection_string
  key_vault_id = azurerm_key_vault.keyvault.id 
}