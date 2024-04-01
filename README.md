# Azure NoOps Management Logging Terraform Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/azurenoops/overlays-template/azurerm/)

This module deploys logging resources (Log Analytics Workspace, Log Solutions and AMPLS) to an operations or security spoke network described in the [Microsoft recommended Hub-Spoke network topology](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation](https://www.cisa.gov/secure-cloud-computing-architecture).

## AMPLS for Azure Monitoring (Azure Managed Private Link Service)

Azure Monitor Private Link Scope connects a Private Endpoint to a set of Azure Monitor resources as [Azure Log Analytics](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-overview). It is a managed service that is deployed and managed by Microsoft.

By default, this module can deploy AMPLS for Azure Monitoring into the privateEndpoint subnet. It creates private dns zone for Azure Monitor services and links the private dns zone to the privateEndpoint ubnet. subnet. It also creates a private endpoint for Azure Monitor services and links the private endpoint to the private dns zone.

DNS Zones:

- `privatelink.monitor.azure.com`
- `privatelink.ods.opinsights.azure.com`
- `privatelink.oms.opinsights.azure.com`
- `privatelink.blob.core.windows.net`
- `privatelink.agentsvc.azure-automation.net`

> **Note:** *`privatelink.blob.core.windows.net` is deployed thru AMPLS make that you do not add this to private dns zones variable. This will cause a conflict, if deployed again to the Management Hub Overlay.*

## Module Usage

```hcl
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_operational_logging" {
  source  = "azurenoops/overlays-management-logging"
  version = ">= 1.0.0"

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
  enable_linked_automation_account_creation        = true
  automation_account_sku_name                      = "Basic"
  automation_account_local_authentication_enabled  = true
  automation_account_public_network_access_enabled = true

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
  enable_azure_activity_log = true
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
  existing_private_subnet_name         = azurerm_subnet.example-snet.name
  ampls_subnet_address_prefix          = ["10.0.1.0/24"]

  # By default, this will apply resource locks to all resources created by this module.
  # To disable resource locks, set the argument to `enable_resource_locks = false`.
  enable_resource_locks = false

  # Tags
  add_tags = {} # Tags to be applied to all resources
}

```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| azurenoopsutils | ~> 1.0.4 |
| azurerm | ~> 3.22 |

## Providers

| Name | Version |
|------|---------|
| azurenoopsutils | ~> 1.0.4 |
| azurerm | ~> 3.22 |
| random | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| lz\_management\_resources | Azure/alz-management/azurerm | ~> 0.1 |
| mod\_aa\_diagnostic\_settings | azurenoops/overlays-diagnostic-settings/azurerm | ~> 1.0 |
| mod\_ampls | azurenoops/overlays-azure-monitor-private-link-scope/azurerm | ~> 0.1 |
| mod\_azure\_region\_lookup | azurenoops/overlays-azregions-lookup/azurerm | >= 1.0.0 |
| mod\_log\_diagnostic\_settings | azurenoops/overlays-diagnostic-settings/azurerm | ~> 1.0 |
| mod\_loganalytics\_sa | azurenoops/overlays-storage-account/azurerm | >= 0.1.0 |
| mod\_scaffold\_rg | azurenoops/overlays-resource-group/azurerm | >= 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.law_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet.ampls_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_user_assigned_identity.management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_id.uniqueString](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [azurenoopsutils_resource_name.ampls_snet](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.automation_account](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.laws](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.logging_st](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurenoopsutils_resource_name.user_assigned_identity](https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| Metric\_enable | Is this Diagnostic Metric enabled? Defaults to true. | `bool` | `true` | no |
| add\_tags | Map of custom tags. | `map(string)` | `{}` | no |
| ampls\_subnet\_address\_prefix | The address prefix for the subnet to be created for Azure Monitor Private Link Scope. | `list(string)` | `null` | no |
| ampls\_subnet\_custom\_name | The name of the custom subnet to create for Azure Monitor Private Link Scope. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| automation\_account\_custom\_name | The name of the custom automation account to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| automation\_account\_key\_vault\_key\_id | The ID of the Key Vault Key to use for Automation Account encryption. | `string` | `null` | no |
| automation\_account\_key\_vault\_url | The URL of the Key Vault to use for Automation Account encryption. | `string` | `null` | no |
| automation\_account\_sku\_name | The SKU of the Automation Account. Possible values are Basic, Free, and Standard. Default is Basic. | `string` | `"Basic"` | no |
| create\_logging\_resource\_group | Controls if the logging resource group should be created. If set to false, the resource group name must be provided. Default is true. | `bool` | `true` | no |
| create\_resource\_group | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false. | `bool` | `false` | no |
| custom\_resource\_group\_name | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| days | The number of days for which this Retention Policy should apply. | `number` | `"90"` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| deploy\_environment | Name of the workload's environnement | `string` | n/a | yes |
| diagnostic\_setting\_enabled\_aa\_log\_categories | A list of log categories to be enabled for this diagnostic setting. | `list(string)` | ```[ "AuditEvent", "Job", "JobStreams", "CompilationJob" ]``` | no |
| diagnostic\_setting\_enabled\_log\_categories | A list of log categories to be enabled for this diagnostic setting. | `list(string)` | ```[ "Audit" ]``` | no |
| diagnostic\_setting\_enabled\_metric\_categories | A list of metric categories to be enabled for this diagnostic setting. | `list(string)` | `[]` | no |
| enable\_ampls | Enable Azure Monitor Private Link Scope | `bool` | `false` | no |
| enable\_automation\_account\_encryption | Controls if encryption should be enabled for the Automation Account. Default is false. | `bool` | `false` | no |
| enable\_automation\_account\_local\_authentication | Controls if local authentication should be enabled for the Automation Account. Default is true. | `bool` | `true` | no |
| enable\_automation\_account\_public\_network\_access | Controls if public network access should be enabled for the Automation Account. Default is true. | `bool` | `true` | no |
| enable\_automation\_account\_user\_assigned\_identity | Controls if a Managed Identity should be created for the Automation Account. Default is false. | `bool` | `false` | no |
| enable\_azure\_activity\_log | Controls if Azure Activity Log should be enabled. Default is true. | `bool` | `false` | no |
| enable\_azure\_security\_center | Controls if Azure Security Center should be enabled. Default is true. | `bool` | `false` | no |
| enable\_container\_insights | Controls if Container Insights should be enabled. Default is true. | `bool` | `false` | no |
| enable\_diagnostic\_setting | Is this Diagnostic Setting enabled? Defaults to true. | `bool` | `true` | no |
| enable\_key\_vault\_analytics | Controls if Key Vault Analytics should be enabled. Default is true. | `bool` | `false` | no |
| enable\_linked\_automation\_account | Controls if a linked Automation Account should be created. Default is true. | `bool` | `true` | no |
| enable\_linked\_automation\_account\_creation | Controls if a linked Automation Account should be created. Default is true. | `bool` | `true` | no |
| enable\_monitoring\_private\_endpoints | Enables private endpoints for monitoring resources. Default is true. | `bool` | `true` | no |
| enable\_resource\_locks | (Optional) Enable resource locks, default is false. If true, resource locks will be created for the resource group and the storage account. | `bool` | `false` | no |
| enable\_sentinel | Controls if Sentinel should be enabled. Default is true. | `bool` | `false` | no |
| enable\_service\_map | Controls if Service Map should be enabled. Default is true. | `bool` | `false` | no |
| enable\_vm\_insights | Controls if VM Insights should be enabled. Default is true. | `bool` | `false` | no |
| environment | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| eventhub\_authorization\_rule\_id | Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data. | `string` | `null` | no |
| eventhub\_name | Specifies the name of the Event Hub where Diagnostics Data should be sent. | `string` | `null` | no |
| existing\_network\_resource\_group\_name | (Required) Name of the resource group for ampls network | `any` | `null` | no |
| existing\_resource\_group\_name | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| existing\_virtual\_network\_name | (Required) Name of the virtual network for ampls | `any` | `null` | no |
| linked\_log\_analytic\_workspace\_ids | The IDs of the Log Analytics Workspaces to link to the Private Link Scope. | `list(string)` | `[]` | no |
| location | Azure region in which instance will be hosted | `string` | n/a | yes |
| lock\_level | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| log\_analytics\_destination\_type | Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table. | `string` | `"AzureDiagnostics"` | no |
| log\_analytics\_logs\_retention\_in\_days | The number of days to retain logs for. Possible values are between 30 and 730. Default is 30. | `number` | `30` | no |
| log\_analytics\_workspace\_allow\_resource\_only\_permissions | Specifies whether the Log Analytics Workspace should only allow access to resources within the same subscription. Defaults to true. | `bool` | `true` | no |
| log\_analytics\_workspace\_cmk\_for\_query\_forced | Specifies whether the Log Analytics Workspace should force the use of Customer Managed Keys for query. Defaults to true. | `bool` | `true` | no |
| log\_analytics\_workspace\_daily\_quota\_gb | The daily ingestion quota in GB for the Log Analytics Workspace. Default is 1. | `number` | `1` | no |
| log\_analytics\_workspace\_id | The ID of the Log Analytics Workspace where logs should be sent. | `string` | `null` | no |
| log\_analytics\_workspace\_internet\_ingestion\_enabled | Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true. | `bool` | `false` | no |
| log\_analytics\_workspace\_internet\_query\_enabled | Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true. | `bool` | `true` | no |
| log\_analytics\_workspace\_reservation\_capacity\_in\_gb\_per\_day | The daily ingestion quota in GB for the Log Analytics Workspace. Default is 200. | `number` | `200` | no |
| log\_analytics\_workspace\_sku | The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018. | `string` | `"PerGB2018"` | no |
| log\_enabled | Is this Diagnostic Log enabled? Defaults to true. | `string` | `true` | no |
| loganalytics\_storage\_account\_kind | The Kind of log analytics storage account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage | `string` | `"StorageV2"` | no |
| loganalytics\_storage\_account\_replication\_type | The Replication Type of log analytics storage account to create. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. | `string` | `"GRS"` | no |
| loganalytics\_storage\_account\_tier | The Tier of log analytics storage account to create. Valid options are Standard and Premium. | `string` | `"Standard"` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| ops\_logging\_law\_custom\_name | The name of the custom operational logging laws workspace to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| ops\_logging\_law\_sa\_custom\_name | The name of the custom operational logging laws storage account to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| org\_name | Name of the organization | `string` | n/a | yes |
| retention\_policy\_enabled | Is this Retention Policy enabled? | `bool` | `false` | no |
| storage\_account\_id | The ID of the Storage Account where logs should be sent. | `string` | `null` | no |
| use\_location\_short\_name | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| use\_naming | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| user\_assigned\_identity\_custom\_name | The name of the custom user assigned identity to create. If not set, the name will be generated using the 'name\_prefix' and 'name\_suffix' variables. If set, the 'name\_prefix' and 'name\_suffix' variables will be ignored. | `string` | `null` | no |
| workload\_name | Name of the workload\_name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| laws\_name | LAWS Name |
| laws\_primary\_shared\_key | LAWS Primary Shared Key |
| laws\_private\_link\_scope\_id | LAWS Private Link ID |
| laws\_resource\_id | LAWS Resource ID |
| laws\_rgname | LAWS Resource Group Name |
| laws\_storage\_account\_id | LAWS Storage Account ID |
| laws\_storage\_account\_location | LAWS Storage Account Location |
| laws\_storage\_account\_name | LAWS Storage Account Name |
| laws\_storage\_account\_rgname | LAWS Storage Account Resource Group Name |
| laws\_workspace\_id | LAWS Workspace ID |
<!-- END_TF_DOCS -->
