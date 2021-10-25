locals {
  module_name = "linux_virtual_machine_scale_set"

  module_tags = {
    module-name = local.module_name
  }
  share_url          = replace(var.share_url, "https:", "")
  primary_access_key = replace(var.primary_access_key, "/", "\\/")
  custom_data_temp_1 = replace(var.custom_data, "%storage_account_name%", var.storage_account_name)
  custom_data_temp_2 = replace(local.custom_data_temp_1, "%share_url%", local.share_url)
  custom_data        = replace(local.custom_data_temp_2, "%primary_access_key%", local.primary_access_key)
}

resource "azurerm_linux_virtual_machine_scale_set" "linux_virtual_machine_scale_set" {
  instances                       = var.instances
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku                             = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  custom_data                     = base64encode(replace(local.custom_data, "%vm_number%", "10"))

  os_disk {
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

  network_interface {
    name    = var.network_interface_name
    primary = true

    ip_configuration {
      name      = var.ip_configuration_name
      primary   = true
      subnet_id = var.ip_configuration_subnet_id
    }
  }

  tags = merge(var.tags, local.module_tags)
}

