variable "resource_group_name" {
  type        = string
  description = "Name of the azure resource group."
}

variable "environment" {
  type        = string
  description = "Name of the deployment environment"
  default     = "prod"
}

variable "location" {
  type        = string
  description = "Location to deploy the resoruce group"
  default     = "West US 2"
}

variable "location_code" {
  type        = string
  description = "Location to deploy the resoruce group"
  default     = "westus2"
}

variable "location_secondary" {
  type        = string
  description = "Location to deploy the resoruce group"
  default     = "East US 2"
}

variable "location_secondary_code" {
  type        = string
  description = "Location to deploy the resoruce group"
  default     = "eastus2"
}

variable "dns_prefix" {
  type        = string
  description = "A prefix for any dns based resources"
  default     = "catech"
}

variable "plan_tier" {
  type        = string
  description = "The tier of app service plan to create"
  default     = "Standard"
}

variable "plan_sku" {
  type        = string
  description = "The sku of app service plan to create"
  default     = "S1"
}