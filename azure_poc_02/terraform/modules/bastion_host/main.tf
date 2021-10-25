locals {
  module_name = "bastion_host"

  module_tags = {
    module-name = local.module_name
  }
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = var.ip_configuration_subnet_id
    public_ip_address_id = var.ip_configuration_public_ip_address_id
  }

  tags = merge(var.tags, local.module_tags)
}
