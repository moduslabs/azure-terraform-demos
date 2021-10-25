locals {
  module_name = "linux_virtual_machine"

  module_tags = {
    module-name = local.module_name
  }
  share_url          = replace(var.share_url, "https:", "")
  primary_access_key = replace(var.primary_access_key, "/", "\\/")
  custom_data_temp_1 = replace(var.custom_data, "%storage_account_name%", var.storage_account_name)
  custom_data_temp_2 = replace(local.custom_data_temp_1, "%share_url%", local.share_url)
  custom_data        = replace(local.custom_data_temp_2, "%primary_access_key%", local.primary_access_key)
}

resource "azurerm_linux_virtual_machine" "linux_virtual_machine" {
  count                           = var.qty
  name                            = "${var.name}-${count.index}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids           = [element(azurerm_network_interface.network_interface.*.id, count.index)]
  custom_data                     = base64encode(replace(local.custom_data, "%vm_number%", "${count.index}"))
  availability_set_id             = azurerm_availability_set.availability_set.id

  os_disk {
    name                 = "${var.os_disk_name}-${count.index}"
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference_publisher
    offer     = var.source_image_reference_offer
    sku       = var.source_image_reference_sku
    version   = var.source_image_reference_version
  }

  identity {
    type = "SystemAssigned"
  }

  tags = merge(var.tags, local.module_tags)
}

# Create a network_interface
resource "azurerm_network_interface" "network_interface" {
  count               = var.qty
  name                = "${var.network_interface_name}-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ip_configuration_name
    subnet_id                     = var.ip_configuration_subnet_id
    private_ip_address_allocation = var.ip_configuration_private_ip_address_allocation
    private_ip_address            = "10.0.0.1${count.index}"
  }

  tags = merge(var.tags, local.module_tags)
}

resource "azurerm_network_interface_backend_address_pool_association" "interface_backend_address_pool_association" {
  count                   = var.qty
  network_interface_id    = element(azurerm_network_interface.network_interface.*.id, count.index)
  ip_configuration_name   = var.ip_configuration_name
  backend_address_pool_id = var.backend_address_pool_id
}

resource "azurerm_availability_set" "availability_set" {
  name                = var.availability_set_name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = merge(var.tags, local.module_tags)
}
