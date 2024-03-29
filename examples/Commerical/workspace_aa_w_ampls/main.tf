# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_logging" {
  source = "../../.." # Path to the root of the repository

  depends_on = [azurerm_resource_group.example-network-rg, azurerm_virtual_network.example-vnet]

  #####################################
  ## Global Settings Configuration  ###
  #####################################

  create_resource_group = true
  location              = var.location
  deploy_environment    = var.deploy_environment
  org_name              = var.org_name
  environment           = var.environment
  workload_name         = var.workload_name

  ########################################
  ## Automation Account Configuration  ###
  ########################################

  # Enable Automation Account Linking to Log Analytics Workspace
  enable_linked_automation_account_creation = true
  automation_account_sku_name               = "Basic"

  #############################
  ## Logging Configuration  ###
  #############################

  # Log Analytics Workspace Configuration
  log_analytics_workspace_allow_resource_only_permissions    = true
  log_analytics_workspace_cmk_for_query_forced               = true
  log_analytics_workspace_daily_quota_gb                     = 1
  log_analytics_workspace_internet_ingestion_enabled         = true
  log_analytics_workspace_internet_query_enabled             = true
  log_analytics_workspace_reservation_capacity_in_gb_per_day = 0 # CapacityReservation is not supported in this configuration
  log_analytics_logs_retention_in_days                       = 50
  log_analytics_workspace_sku                                = "PerGB2018"

  # (Optional) Logging Solutions
  # All solutions are not enabled (false) by default
  enable_sentinel           = true
  enable_azure_activity_log = false
  enable_vm_insights        = true

  #############################
  ## Misc Configuration     ###
  #############################

  # (Optional) To enable Azure Monitoring Private Link Scope
  # Enable Azure Monitor Private Link Scope
  enable_ampls = true

  # AMPLS Configuration
  existing_network_resource_group_name = azurerm_resource_group.example-network-rg.name
  existing_virtual_network_name        = azurerm_virtual_network.example-vnet.name
  ampls_subnet_address_prefix          = ["10.0.1.0/24"]

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}
