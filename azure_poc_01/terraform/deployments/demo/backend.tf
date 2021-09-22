# https://github.com/hashicorp/terraform/releases
# https://github.com/terraform-providers/terraform-provider-azurerm/releases
terraform {
  required_version = "1.0.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.76.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "poc-terraform-tfstate"
    storage_account_name = "pocfmsterraform"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}