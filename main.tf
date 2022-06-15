terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# Follow the #COMMENTS in this Terraform Script

provider "azurerm" {
  features {}

}
# Get Resources from a Resource Group
data "azurerm_resources" "rgname" {
  resource_group_name = var.rgname

  required_tags = {
    #REPLACE 26-ShashankNarayanan WITH YOUR TAG
    project = "26-ShashankNarayanan"
  }
}

resource "azurerm_kubernetes_cluster" "sn-cluster" {

  name                = "create-kubernetes-cluster-sn"
  location            = var.location
  resource_group_name = var.rgname
  dns_prefix          = "create-kubernetes-cluster-sn-dns"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "starter"
    vm_size    = "Standard_DS2_v2"
    node_count = 4
    type       = "VirtualMachineScaleSets"

  }

}

resource "azurerm_kubernetes_cluster_node_pool" "sfs_pool" {
  name                  = "sfs"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.sn-cluster.id
  vm_size               = "Standard_DS2_v2"
  max_count             = 5
  min_count             = 1
  os_disk_size_gb       = 128
  os_type               = "Linux"
  enable_auto_scaling   = true

  tags = {
    project = "26-ShashankNarayanan"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "elk_pool" {
  name                  = "elk"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.sn-cluster.id
  vm_size               = "Standard_DS2_v2"
  max_count             = 5
  min_count             = 1
  os_disk_size_gb       = 128
  os_type               = "Linux"
  enable_auto_scaling   = true

  tags = {
    project = "26-ShashankNarayanan"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "synapps_pool" {
  name                  = "synapps"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.sn-cluster.id
  vm_size               = "Standard_DS2_v2"
  max_count             = 5
  min_count             = 1
  os_disk_size_gb       = 128
  os_type               = "Linux"
  enable_auto_scaling   = true

  tags = {
    project = "26-ShashankNarayanan"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.sn-cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.sn-cluster.kube_config_raw

  sensitive = true
}
