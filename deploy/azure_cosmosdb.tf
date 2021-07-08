resource "azurerm_cosmosdb_account" "db" {
  name                = "${var.dns_prefix}${var.environment}db"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.default.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  capabilities {
    name = "MongoDBv3.4"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  geo_location {
    location          = var.location_secondary
    failover_priority = 1
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}