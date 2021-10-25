variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}
variable "name" {
  description = "The name of the Linux Virtual Machine. Changing this forces a new resource to be created."
}
variable "resource_group_name" {
  description = "Name of the parent resource group"
}
variable "location" {
  description = "Location of the virtual network"
}
variable "size" {
  description = "The SKU which should be used for this Virtual Machine, such as Standard_F2"
}
variable "admin_username" {
  description = "The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created"
}
variable "admin_password" {
  description = "The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created"
}
variable "disable_password_authentication" {
  description = "Should Password Authentication be disabled on this Virtual Machine? Defaults to true. Changing this forces a new resource to be created"
}
variable "os_disk_name" {
  description = "The name which should be used for the Internal OS Disk. Changing this forces a new resource to be created"
}
variable "os_disk_caching" {
  description = "The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite"
}
variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS and Premium_LRS. Changing this forces a new resource to be created"
}
variable "source_image_reference_publisher" {
  description = "Specifies the Publisher of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created"
}
variable "source_image_reference_offer" {
  description = "Specifies the offer of the image used to create the virtual machines"
}
variable "source_image_reference_sku" {
  description = "Specifies the SKU of the image used to create the virtual machines"
}
variable "source_image_reference_version" {
  description = "Specifies the version of the image used to create the virtual machines"
}
variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created"
}
variable "ip_configuration_name" {
  description = "A name used for this IP Configuration"
}
variable "ip_configuration_subnet_id" {
  description = "The ID of the Subnet where this Network Interface should be located in"
}
variable "ip_configuration_private_ip_address_allocation" {
  description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static"
}
variable "network_interface_name" {
  description = "The name of the Network Interface. Changing this forces a new resource to be created."
}
variable "qty" {
  description = "How many virtual machines should be created"
}
variable "storage_account_name" {
  description = "Used to connect to share"
}
variable "primary_access_key" {
  description = "Used to connect to share"
}
variable "share_url" {
  description = "Used to connect to share"
}
variable "backend_address_pool_id" {
  description = "The ID of the Load Balancer Backend Address Pool which this Network Interface should be connected to. Changing this forces a new resource to be created."
}
variable "availability_set_name" {
  description = "Specifies the name of the availability set. Changing this forces a new resource to be created."
}
