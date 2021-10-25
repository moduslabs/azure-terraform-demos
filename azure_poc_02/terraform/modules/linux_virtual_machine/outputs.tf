output "network_interface_id" {
  value = join(",", azurerm_network_interface.network_interface[*].id)
}
