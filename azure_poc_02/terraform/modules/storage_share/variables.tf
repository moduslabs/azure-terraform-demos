variable "name" {
  description = "The name of the share. Must be unique within the storage account where the share is located."
}
variable "storage_account_name" {
  description = " Specifies the storage account in which to create the share. Changing this forces a new resource to be created."
}
variable "quota" {
  description = "The maximum size of the share, in gigabytes. For Standard storage accounts, this must be greater than 0 and less than 5120 GB (5 TB). For Premium FileStorage storage accounts, this must be greater than 100 GB and less than 102400 GB (100 TB). Default is 5120."
}
variable "acl_id" {
  description = "The ID which should be used for this Shared Identifier."
}
variable "acl_permissions" {
  description = "The permissions which should be associated with this Shared Identifier. Possible value is combination of r (read), w (write), d (delete), and l (list)."
}