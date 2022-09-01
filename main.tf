terraform {
  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.20.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
#Resource Group

resource "azurerm_resource_group" "example" {
  name     = "AKS-Testing-Group"
  location = "West Europe"
}

