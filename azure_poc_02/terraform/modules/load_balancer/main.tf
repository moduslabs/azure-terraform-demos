locals {
  module_name = "load_balancer"

  module_tags = {
    module-name = local.module_name
  }
}
resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = var.fic_name
    public_ip_address_id = var.fic_public_ip_address_id
  }

  tags = merge(var.tags, local.module_tags)
}
resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name            = "${var.name}-backend_address_pool"
  loadbalancer_id = azurerm_lb.lb.id
}
resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "http"
  protocol            = "Http"
  request_path        = "/"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = var.fic_name
  probe_id                       = azurerm_lb_probe.lb_probe.id
  idle_timeout_in_minutes        = 4
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend_address_pool.id]
}
