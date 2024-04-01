# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

 resource "azurerm_resource_group" "example-network-rg" {
  name     = "example-network-rg"
  location = var.location
  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_network" "example-vnet" {
  depends_on = [
    azurerm_resource_group.example-network-rg
  ]
  name                = "example-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.example-network-rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "test"
  }
}

resource "azurerm_network_security_group" "example-nsg" {
  depends_on = [
    azurerm_resource_group.example-network-rg,
  ]
  name                = "example-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.example-network-rg.name
  tags = {
    environment = "test"
  }
}
