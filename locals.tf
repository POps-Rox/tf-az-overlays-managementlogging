# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------
# Local declarations
#---------------------------------
resource "random_id" "uniqueString" {
  keepers = {
    # Generate a new id each time we change resourcePrefix variable
    org_prefix = var.org_name
    subid      = var.workload_name
  }
  byte_length = 3
}

locals {
  # Path: src\terraform\azresources\modules\Microsoft.Security\azureSecurityCenter\main.tf
  # Name: azureSecurityCenter
  # Description: Azure Security Center

  log_analytics_solutions = [
    {
      deploy : var.enable_azure_activity_log
      name : "AzureActivity"
      product : "OMSGallery/AzureActivity"
      publisher : "Microsoft"
    },
    {
      deploy : var.enable_sentinel
      name : "SecurityInsights"
      product : "OMSGallery/SecurityInsights"
      publisher : "Microsoft"
    },
    {
      deploy : var.enable_vm_insights
      name : "VMInsights"
      product : "OMSGallery/VMInsights"
      publisher : "Microsoft"
    },
    {
      deploy : var.enable_azure_security_center
      name : "Security"
      product : "OMSGallery/Security"
      publisher : "Microsoft"
    },
    {
      deploy : var.enable_service_map
      name : "ServiceMap"
      publisher : "Microsoft"
      product : "OMSGallery/ServiceMap"
    },
    {
      deploy : var.enable_container_insights
      name : "ContainerInsights"
      publisher : "Microsoft"
      product : "OMSGallery/ContainerInsights"
    },
    {
      deploy : var.enable_key_vault_analytics
      name : "KeyVaultAnalytics"
      publisher : "Microsoft"
      product : "OMSGallery/KeyVaultAnalytics"
    }
  ]
}
