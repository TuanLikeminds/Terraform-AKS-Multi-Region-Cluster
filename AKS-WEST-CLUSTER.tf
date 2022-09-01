#West AKS Cluster

#data object grabs the subnet data from the West Vnet
data "azurerm_subnet" "subnet-west" {
  name                 = "West-AKS-Vnet-subnet"
  virtual_network_name = azurerm_virtual_network.Vnet-West.name
  resource_group_name  = azurerm_resource_group.example.name
}


resource "azurerm_kubernetes_cluster" "West-AKS-Cluster" {
  name                = "West-AKS-Cluster"
  location            = azurerm_virtual_network.Vnet-West.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "West-AKS-Cluster"
  


  default_node_pool {
    name           = "pingpoolw"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = data.azurerm_subnet.subnet-west.id
    os_sku         = "Ubuntu"
    
  }
#Setting Azure CNI to enable deploying the cluster on existing subnet
 network_profile {
    network_plugin     = "azure"
    load_balancer_sku  = "standard"
    #network_policy     = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
  }
}

output "client_certificate_west" {
  value     = azurerm_kubernetes_cluster.West-AKS-Cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config_west" {
  value = azurerm_kubernetes_cluster.West-AKS-Cluster.kube_config_raw

  sensitive = true
}

output "kubernetes-cluster-name-west" {
  value = azurerm_kubernetes_cluster.West-AKS-Cluster.name

  sensitive = true
}