resource "azurerm_storage_account" "unemployment" {
  name                     = "${var.dns_prefix}${var.environment}unemp"
  resource_group_name      = data.azurerm_resource_group.default.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  allow_blob_public_access = true
}
