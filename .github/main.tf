/*

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.38.0"
    }
  }
}

provider "azurerm" {
  # Configuration options for the above-mentioned Azure Provider 

subscription_id = "d7f702bf-9da6-45cf-b201-e2f546f03408"
tenant_id = "dfe21b68-66ac-46dd-9af5-dbc58545a2c4"
client_id = "a83f335a-5eca-40c8-ba17-5baf0d0c381d"
client_secret = "ROI8Q~n-QLwYYN_gpalDTakNicMCvRyIPAKFsce3"

features {}
 
}

*/

locals {

  resource_group_name = "app-grp"
  location = "Canada Central"
  virtual_network = {
    name = "vnet-dev"
    vnet_cidr = "10.1.0.0/16"
  }

  subnets = [
    {
      name = "subnet-01"
      prefix = "10.1.1.0/24"
    },

    {
      name = "subnet-02"
      prefix = "10.1.2.0/24"
    }

  ]

}


resource "azurerm_resource_group" "tf-app-grp" {
  # Name_Label used inside Terraform Configuration File
  # Resource_Label used for actual Azure resource

  name     = local.resource_group_name
  location = local.location

}

resource "azurerm_virtual_network" "tf-vnet-dev" {
  name                = local.virtual_network.name
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = [local.virtual_network.vnet_cidr]

  depends_on = [
    azurerm_resource_group.tf-app-grp
  ]

}

resource "azurerm_subnet" "tf-subnetA" {
  name                 = local.subnets[0].name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnets[0].prefix]

  depends_on = [
    azurerm_virtual_network.tf-vnet-dev
  ]

}

resource "azurerm_subnet" "tf-subnetB" {
  name                 = local.subnets[1].name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = [local.subnets[1].prefix]

  depends_on = [
    azurerm_virtual_network.tf-vnet-dev
  ]

}

resource "azurerm_network_interface" "tf-appinterface-01" {
  name                = "appinterface-01"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.tf-subnetA.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [
    azurerm_subnet.tf-subnetA
  ]
}

resource "azurerm_network_interface" "tf-appinterface-02" {
    name                = "appinterface-02"
    location            = local.location
    resource_group_name = local.resource_group_name
  
    ip_configuration {
      name                          = "internal"
      subnet_id                     = azurerm_subnet.tf-subnetB.id
      private_ip_address_allocation = "Dynamic"
    }
    depends_on = [
      azurerm_subnet.tf-subnetB
    ]
  }
  
