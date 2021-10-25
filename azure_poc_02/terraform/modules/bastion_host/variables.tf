variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}
variable "name" {
  description = "Specifies the name of the Bastion Host. Changing this forces a new resource to be created."
}
variable "resource_group_name" {
  description = "Name of the parent resource group"
}
variable "location" {
  description = "Location of the virtual network"
}
variable "ip_configuration_name" {
  description = "The name of the IP configuration."
}
variable "ip_configuration_subnet_id" {
  description = "Reference to a subnet in which this Bastion Host has been created."
}
variable "ip_configuration_public_ip_address_id" {
  description = "Reference to a Public IP Address to associate with this Bastion Host."
}

