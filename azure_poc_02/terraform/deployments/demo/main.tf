# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

locals {
  # Local variables for resource tags
  tag_creator    = "terraform"
  tag_tf_version = "1.0.9"
}

# Create a resource group
module "resource_group_01" {
  source   = "../../modules/resource_group/"
  name     = "${var.project_name}-rg-${var.region}-${var.stage}"
  location = var.location

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}

# Create a Virtual Network
module "virtual_network" {
  source              = "../../modules/virtual_network/"
  name                = "${var.project_name}-vnet-01-${var.region}-${var.stage}"
  resource_group_name = module.resource_group_01.name
  location            = module.resource_group_01.location
  address_space       = [var.vnet_01_address_space]

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}

# Create a Public IP
module "public_ip" {
  source              = "../../modules/public_ip/"
  resource_group_name = module.resource_group_01.name
  location            = module.resource_group_01.location
  name                = "${var.project_name}-pip-01-${var.region}-${var.stage}"
  domain_name_label   = "${var.stage}-${var.project_name}-pip-01"
  ip_version          = "IPv4"
  sku                 = "Basic"
  allocation_method   = "Static"

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}
module "public_ip_bastion_host" {
  source              = "../../modules/public_ip/"
  resource_group_name = module.resource_group_01.name
  location            = module.resource_group_01.location
  name                = "${var.project_name}-pip-02-${var.region}-${var.stage}"
  domain_name_label   = "${var.stage}-${var.project_name}-pip-02"
  ip_version          = "IPv4"
  sku                 = "Standard"
  allocation_method   = "Static"

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}

# Create a Load Balancer
module "load_balancer" {
  source                   = "../../modules/load_balancer/"
  name                     = "${var.project_name}-lb-01-${var.region}-${var.stage}"
  location                 = module.resource_group_01.location
  resource_group_name      = module.resource_group_01.name
  fic_name                 = "pip"
  fic_public_ip_address_id = module.public_ip.id

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}

# Create Subnet
# Subnet_01 = Used for Docker Swarm Managers
module "subnet_01" {
  source               = "../../modules/subnet/"
  name                 = "${var.project_name}-snet-01-${var.region}-${var.stage}"
  resource_group_name  = module.resource_group_01.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.subnet_01_address_prefix
}

# Subnet_02 = Used for Docker Swarm Workers
module "subnet_02" {
  source               = "../../modules/subnet/"
  name                 = "${var.project_name}-snet-02-${var.region}-${var.stage}"
  resource_group_name  = module.resource_group_01.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.subnet_02_address_prefix
}

# Subnet Bastion Host = Used for Bastion Host
module "subnet_bastion_host" {
  source               = "../../modules/subnet/"
  name                 = "AzureBastionSubnet"
  resource_group_name  = module.resource_group_01.name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.subnet_03_address_prefix
}

# Create a Bastion Host to access the Swarm Nodes
module "bastion_host" {
  source              = "../../modules/bastion_host/"
  name                = "${var.project_name}-bh-${var.region}-${var.stage}"
  location            = module.resource_group_01.location
  resource_group_name = module.resource_group_01.name

  ip_configuration_name                 = "${var.project_name}-bh-ip-${var.region}-${var.stage}"
  ip_configuration_subnet_id            = module.subnet_bastion_host.id
  ip_configuration_public_ip_address_id = module.public_ip_bastion_host.id

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}

# Create Virtual Machine(s) - Docker Swarm Manager Nodes
module "linux_virtual_machine_manager" {
  source                                         = "../../modules/linux_virtual_machine/"
  qty                                            = 3 #odd number
  name                                           = "${var.project_name}-vm-${var.region}-${var.stage}"
  location                                       = module.resource_group_01.location
  resource_group_name                            = module.resource_group_01.name
  size                                           = "Standard_B2s"
  admin_username                                 = "ubuntu"
  admin_password                                 = "This~is#a!P0C" # password explicity just for a PoC - do not use in production - use KeyVault
  disable_password_authentication                = false
  os_disk_name                                   = "${var.project_name}-vm-disk-${var.region}-${var.stage}"
  os_disk_caching                                = "ReadWrite"
  os_disk_storage_account_type                   = "Standard_LRS"
  source_image_reference_publisher               = "canonical"
  source_image_reference_offer                   = "0001-com-ubuntu-server-focal"
  source_image_reference_sku                     = "20_04-lts"
  source_image_reference_version                 = "latest"
  custom_data                                    = file("docker-swarm.sh")
  network_interface_name                         = "${var.project_name}-ni-${var.region}-${var.stage}"
  ip_configuration_name                          = "${var.project_name}-vm-ip-${var.region}-${var.stage}"
  ip_configuration_subnet_id                     = module.subnet_01.id
  ip_configuration_private_ip_address_allocation = "Static"
  backend_address_pool_id                        = module.load_balancer.lb_backend_address_pool_id
  availability_set_name                          = "${var.project_name}-as-${var.region}-${var.stage}"

  storage_account_name = module.storage_account.name
  primary_access_key   = module.storage_account.primary_access_key
  share_url            = module.storage_share.url

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}

# Create Virtual Machine(s) - Docker Swarm Worker Nodes
module "linux_virtual_machine_worker" {
  source                           = "../../modules/linux_virtual_machine_scale_set/"
  instances                        = 2
  name                             = "${var.project_name}-vm-ss-${var.region}-${var.stage}"
  location                         = module.resource_group_01.location
  resource_group_name              = module.resource_group_01.name
  size                             = "Standard_B2s"
  admin_username                   = "ubuntu"
  admin_password                   = "This~is#a!P0C" # password explicity just for a PoC - do not use in production - use KeyVault
  disable_password_authentication  = false
  os_disk_name                     = "${var.project_name}-vm-disk-${var.region}-${var.stage}"
  os_disk_caching                  = "ReadWrite"
  os_disk_storage_account_type     = "Standard_LRS"
  source_image_reference_publisher = "canonical"
  source_image_reference_offer     = "0001-com-ubuntu-server-focal"
  source_image_reference_sku       = "20_04-lts"
  source_image_reference_version   = "latest"
  custom_data                      = file("docker-swarm.sh")
  network_interface_name           = "${var.project_name}-ni-${var.region}-${var.stage}"
  ip_configuration_name            = "${var.project_name}-vm-ip-${var.region}-${var.stage}"
  ip_configuration_subnet_id       = module.subnet_02.id

  storage_account_name = module.storage_account.name
  primary_access_key   = module.storage_account.primary_access_key
  share_url            = module.storage_share.url

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}

# Create a Storage Account to share files between Docker Swarm Nodes
module "storage_account" {
  source                   = "../../modules/storage_account/"
  name                     = "${var.project_name}storage${var.region}${var.stage}"
  location                 = module.resource_group_01.location
  resource_group_name      = module.resource_group_01.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    creator    = local.tag_creator
    tf-version = local.tag_tf_version
    env        = var.stage
  }
}

module "storage_share" {
  source               = "../../modules/storage_share/"
  name                 = "${var.project_name}-share-${var.region}-${var.stage}"
  storage_account_name = module.storage_account.name
  quota                = 1
  acl_id               = "${var.project_name}-ss-acl-${var.region}-${var.stage}"
  acl_permissions      = "rwdl"
}

