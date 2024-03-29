# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#######################################
# Azure Monitor Private Link Scope   ##
#######################################

resource "azurerm_subnet" "ampls_subnet" {
  name                 = local.ampls_subnet_name
  resource_group_name  = var.existing_network_resource_group_name
  virtual_network_name = var.existing_virtual_network_name
  address_prefixes     = var.ampls_subnet_address_prefix
}

module "mod_ampls" {
  source  = "azurenoops/overlays-azure-monitor-private-link-scope/azurerm"
  version = "~> 0.1"

  count = var.enable_ampls ? 1 : 0

  depends_on = [module.lz_management_resources, azurerm_subnet.ampls_subnet]

  # Resource Group, location, VNet and Subnet details
  create_resource_group = true
  location              = var.location
  deploy_environment    = var.deploy_environment
  environment           = var.environment
  org_name              = var.org_name

  # Log Analytics Workspaces
  linked_log_analytic_workspace_ids = concat([module.lz_management_resources.log_analytics_workspace.id], var.linked_log_analytic_workspace_ids)

  # Private Endpoint details
  # Resource Group, location, VNet and Subnet details
  # This need to be the same as the VNet and Subnet where the Private Endpoint will be deployed
  existing_ampls_network_resource_group_name = var.existing_network_resource_group_name
  existing_ampls_virtual_network_name        = var.existing_virtual_network_name
  existing_ampls_private_subnet_name         = azurerm_subnet.ampls_subnet.name
}
