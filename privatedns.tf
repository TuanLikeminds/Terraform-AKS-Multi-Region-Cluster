#Create Private DNS Zone and Link the Two Virtual Networks
resource "azurerm_private_dns_zone" "example" {
  name                = "likeminds-devops.com"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "West-DNS-LINK" {
  name                  = "West-DNS-Link"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.Vnet-West.id
  registration_enabled  = "true"
}

resource "azurerm_private_dns_zone_virtual_network_link" "EAST-DNS-LINK" {
  name                  = "East-DNS-Link"
  resource_group_name   = azurerm_resource_group.example.name
  private_dns_zone_name = azurerm_private_dns_zone.example.name
  virtual_network_id    = azurerm_virtual_network.Vnet-East.id
  registration_enabled  = "true"

}