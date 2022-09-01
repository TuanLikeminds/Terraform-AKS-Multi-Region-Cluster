

resource "azurerm_network_security_group" "example" {
  name                = "example-security-group"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}


#West Vnet
resource "azurerm_virtual_network" "Vnet-West" {
  name                = "West-Vnet"
  location            = "West US"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.30.0.0/16"]
  dns_servers         = ["10.30.0.4", "10.30.0.5"]
  #This is where the aks cluster will be deployed
  subnet {
    name           = "West-AKS-Vnet-subnet"
    address_prefix = "10.30.1.0/24"
  }

  tags = {
    environment = "Testing"
  }
}


#East Vnet
resource "azurerm_virtual_network" "Vnet-East" {
  name                = "East-Vnet"
  location            = "East US 2"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.31.0.0/16"]
  dns_servers         = ["10.31.0.0.4", "10.31.0.0.5"]

  subnet {
    name           = "East-AKS-Vnet-subnet"
    address_prefix = "10.31.1.0/24"
  }

  tags = {
    environment = "Testing"
  }
}

#Peering between East and West Clusters
resource "azurerm_virtual_network_peering" "West-to-east-Peering" {
  name                      = "West-to-east-Peering"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.Vnet-West.name
  remote_virtual_network_id = azurerm_virtual_network.Vnet-East.id
}

resource "azurerm_virtual_network_peering" "East-to-west-Peering" {
  name                      = "East-to-West-Peering"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.Vnet-East.name
  remote_virtual_network_id = azurerm_virtual_network.Vnet-West.id
}

#Success