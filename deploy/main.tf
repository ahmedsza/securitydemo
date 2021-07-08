terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    key_vault {
      recover_soft_deleted_key_vaults = true
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_resource_group" "default" {
  name = var.resource_group_name
}

terraform {
  backend "azurerm" {
    key = "terraform.tfstate"
  }
}