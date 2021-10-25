locals {
  module_name = "storage_account_share"

  module_tags = {
    module-name = local.module_name
  }
}
resource "azurerm_storage_share" "storage_share" {
  name                 = var.name
  storage_account_name = var.storage_account_name
  quota                = var.quota

  acl {
    id = var.acl_id

    access_policy {
      permissions = var.acl_permissions
    }
  }
}