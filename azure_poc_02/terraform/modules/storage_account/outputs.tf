output "name" {
  value = azurerm_storage_account.storage_account.name
}

output "primary_access_key" {
  value = azurerm_storage_account.storage_account.primary_access_key
}

output "primary_blob_host" {
  value = azurerm_storage_account.storage_account.primary_blob_host
}