resource "azurerm_frontdoor" "unemployment" {
  count                                        = var.environment == "prod" ? 1 : 0
  name                                         = "${var.dns_prefix}unemployment"
  resource_group_name                          = data.azurerm_resource_group.default.name
  enforce_backend_pools_certificate_name_check = false

  frontend_endpoint {
    name                              = "frontend"
    host_name                         = "${var.dns_prefix}unemployment.azurefd.net"
    custom_https_provisioning_enabled = false
  }

  routing_rule {
    name               = "unemploymentRouting"
    accepted_protocols = ["Http", "Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["frontend"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "unemploymentBackendPool"
    }
  }

  backend_pool_load_balancing {
    name = "unemploymentLoadBalancingSettings"
  }

  backend_pool_health_probe {
    name = "unemploymentHealthProbeSettings"
  }

  backend_pool {
    name = "unemploymentBackendPool"
    backend {
      host_header = azurerm_app_service.unemployment.default_site_hostname
      address     = azurerm_app_service.unemployment.default_site_hostname
      http_port   = 80
      https_port  = 443
      weight      = 50
      enabled     = true
    }

    backend {
      host_header = azurerm_app_service.unemployment_secondary[0].default_site_hostname
      address     = azurerm_app_service.unemployment_secondary[0].default_site_hostname
      http_port   = 80
      https_port  = 443
      weight      = 50
      enabled     = true
    }

    load_balancing_name = "unemploymentLoadBalancingSettings"
    health_probe_name   = "unemploymentHealthProbeSettings"
  }
}