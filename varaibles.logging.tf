# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###########################
# Logging Configuration  ##
###########################

variable "create_logging_resource_group" {
  description = "Controls if the logging resource group should be created. If set to false, the resource group name must be provided. Default is true."
  type        = bool
  default     = true
}

variable "enable_monitoring_private_endpoints" {
  description = "Enables private endpoints for monitoring resources. Default is true."
  type        = bool
  default     = true
}

variable "linked_log_analytic_workspace_ids" {
  description = "The IDs of the Log Analytics Workspaces to link to the Private Link Scope."
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_sku" {
  description = "The SKU of the Log Analytics Workspace. Possible values are PerGB2018 and Free. Default is PerGB2018."
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_logs_retention_in_days" {
  description = "The number of days to retain logs for. Possible values are between 30 and 730. Default is 30."
  type        = number
  default     = 30
}

variable "log_analytics_workspace_reservation_capacity_in_gb_per_day" {
  description = "The daily ingestion quota in GB for the Log Analytics Workspace. Default is 200."
  type        = number
  default     = 200
}

variable "log_analytics_workspace_daily_quota_gb" {
  description = "The daily ingestion quota in GB for the Log Analytics Workspace. Default is 1."
  type        = number
  default     = 1
}

variable "log_analytics_workspace_allow_resource_only_permissions" {
  type        = bool
  default     = true
  description = "Specifies whether the Log Analytics Workspace should only allow access to resources within the same subscription. Defaults to true."
}

variable "log_analytics_workspace_cmk_for_query_forced" {
  type        = bool
  default     = true
  description = "Specifies whether the Log Analytics Workspace should force the use of Customer Managed Keys for query. Defaults to true."
}


variable "log_analytics_workspace_internet_ingestion_enabled" {
  type        = bool
  default     = false
  description = "Should the Log Analytics Workspace support ingestion over the Public Internet? Defaults to true."
}

variable "log_analytics_workspace_internet_query_enabled" {
  type        = bool
  default     = true
  description = "Should the Log Analytics Workspace support querying over the Public Internet? Defaults to true."
}

#####################################
# Log Solutions Configuration     ##
#####################################

variable "enable_sentinel" {
  description = "Controls if Sentinel should be enabled. Default is true."
  type        = bool
  default     = false
}

variable "enable_azure_activity_log" {
  description = "Controls if Azure Activity Log should be enabled. Default is true."
  type        = bool
  default     = false
}

variable "enable_vm_insights" {
  description = "Controls if VM Insights should be enabled. Default is true."
  type        = bool
  default     = false
}

variable "enable_azure_security_center" {
  description = "Controls if Azure Security Center should be enabled. Default is true."
  type        = bool
  default     = false
}

variable "enable_service_map" {
  description = "Controls if Service Map should be enabled. Default is true."
  type        = bool
  default     = false
}

variable "enable_container_insights" {
  description = "Controls if Container Insights should be enabled. Default is true."
  type        = bool
  default     = false
}

variable "enable_key_vault_analytics" {
  description = "Controls if Key Vault Analytics should be enabled. Default is true."
  type        = bool
  default     = false
}

#######################################
# Automation Account Configuration   ##
#######################################

variable "enable_automation_account_user_assigned_identity" {
  description = "Controls if a Managed Identity should be created for the Automation Account. Default is false."
  type        = bool
  default     = false
}

variable "enable_automation_account_encryption" {
  description = "Controls if encryption should be enabled for the Automation Account. Default is false."
  type        = bool
  default     = false
}

variable "enable_automation_account_local_authentication" {
  description = "Controls if local authentication should be enabled for the Automation Account. Default is true."
  type        = bool
  default     = true
}

variable "enable_automation_account_public_network_access" {
  description = "Controls if public network access should be enabled for the Automation Account. Default is true."
  type        = bool
  default     = true
}

variable "automation_account_sku_name" {
  description = "The SKU of the Automation Account. Possible values are Basic, Free, and Standard. Default is Basic."
  type        = string
  default     = "Basic"
}

variable "enable_linked_automation_account_creation" {
  description = "Controls if a linked Automation Account should be created. Default is true."
  type        = bool
  default     = true
}

variable "enable_linked_automation_account" {
  description = "Controls if a linked Automation Account should be created. Default is true."
  type        = bool
  default     = true
}

variable "automation_account_key_vault_key_id" {
  description = "The ID of the Key Vault Key to use for Automation Account encryption."
  type        = string
  default     = null
}

variable "automation_account_key_vault_url" {
  description = "The URL of the Key Vault to use for Automation Account encryption."
  type        = string
  default     = null
}

#############################################
# Log Diagnostic Setting Configuration     ##
#############################################

variable "enable_diagnostic_setting" {
  description = "Is this Diagnostic Setting enabled? Defaults to true."
  type        = bool
  default     = true
}

variable "log_analytics_destination_type" {
  type        = string
  default     = "AzureDiagnostics"
  description = "Possible values are AzureDiagnostics and Dedicated, default to AzureDiagnostics. When set to Dedicated, logs sent to a Log Analytics workspace will go into resource specific tables, instead of the legacy AzureDiagnostics table."
}
variable "retention_policy_enabled" {
  type        = bool
  default     = false
  description = "Is this Retention Policy enabled?"
}
variable "days" {
  type        = number
  default     = "90"
  description = " The number of days for which this Retention Policy should apply."
}
variable "Metric_enable" {
  type        = bool
  default     = true
  description = "Is this Diagnostic Metric enabled? Defaults to true."
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace where logs should be sent."
  type        = string
  default     = null
}

variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)
  default     = ["Audit"]
}

variable "diagnostic_setting_enabled_aa_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)
  default     = ["AuditEvent", "Job", "JobStreams", "CompilationJob"]
}

variable "diagnostic_setting_enabled_metric_categories" {
  description = "A list of metric categories to be enabled for this diagnostic setting."
  type        = list(string)
  default     = []
}

variable "log_enabled" {
  type        = string
  default     = true
  description = " Is this Diagnostic Log enabled? Defaults to true."
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "The ID of the Storage Account where logs should be sent."
}

variable "eventhub_name" {
  type        = string
  default     = null
  description = "Specifies the name of the Event Hub where Diagnostics Data should be sent."
}

variable "eventhub_authorization_rule_id" {
  type        = string
  default     = null
  description = "Specifies the ID of an Event Hub Namespace Authorization Rule used to send Diagnostics Data."
}
