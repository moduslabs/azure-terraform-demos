locals {
  module_name = "storage_account"

  module_tags = {
    module-name = local.module_name
  }
}
resource "azurerm_storage_account" "storage_account" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = merge(var.tags, local.module_tags)
}