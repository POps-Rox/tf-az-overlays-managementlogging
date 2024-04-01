# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Operations Log Analytics Workspace Role Assignment
#----------------------------------------------------------
resource "azurerm_role_assignment" "law_contributor" {
  scope                = module.lz_management_resources.log_analytics_workspace.id
  role_definition_name = "Log Analytics Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}
