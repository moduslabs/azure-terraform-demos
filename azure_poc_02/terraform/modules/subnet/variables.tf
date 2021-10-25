variable "name" {
  description = "The name of the subnet. Changing this forces a new resource to be created."
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
}
variable "virtual_network_name" {
  description = "The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
}
variable "address_prefixes" {
  description = "The address prefixes to use for the subnet."
}