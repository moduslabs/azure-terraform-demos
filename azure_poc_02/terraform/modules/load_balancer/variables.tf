variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}
variable "name" {
  description = "Specifies the name of the Load Balancer."
}
variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the Load Balancer."
}
variable "location" {
  description = "Specifies the supported Azure Region where the Load Balancer should be created."
}
variable "fic_name" {
  description = "Specifies the name of the frontend ip configuration."
}
variable "fic_public_ip_address_id" {
  description = "The ID of a Public IP Address which should be associated with the Load Balancer."
}
