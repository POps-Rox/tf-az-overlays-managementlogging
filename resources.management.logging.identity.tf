# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#################################
# Azure User Assigned Identity  #
#################################
resource "azurerm_user_assigned_identity" "management" {
  count               = var.enable_linked_automation_account_creation && var.enable_automation_account_user_assigned_identity ? 1 : 0
  location            = local.location
  name                = local.user_assigned_identity_name
  resource_group_name = local.resource_group_name
}
