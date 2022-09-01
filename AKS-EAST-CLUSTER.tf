#East AKS Cluster

#data object grabs the subnet data from the East Vnet
data "azurerm_subnet" "subnet-east" {
  name                 = "East-AKS-Vnet-subnet"
  virtual_network_name = azurerm_virtual_network.Vnet-East.name
  resource_group_name  = azurerm_resource_group.example.name
}


resource "azurerm_kubernetes_cluster" "East-AKS-Cluster" {
  name                = "East-AKS-Cluster"
  location            = azurerm_virtual_network.Vnet-East.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "East-AKS-Cluster"



  default_node_pool {
    name           = "pingpoole"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = data.azurerm_subnet.subnet-east.id
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

output "client_certificate_east" {
  value     = azurerm_kubernetes_cluster.East-AKS-Cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_confi-east" {
  value = azurerm_kubernetes_cluster.East-AKS-Cluster.kube_config_raw

  sensitive = true
}

output "kubernetes-cluster-name-east" {
  value = azurerm_kubernetes_cluster.East-AKS-Cluster.name

  sensitive = true
}