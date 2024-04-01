# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.


###########################
# Global Configuration   ##
###########################

variable "location" {
  description = "Azure region in which instance will be hosted"
  type        = string
}

variable "environment" {
  description = "The Terraform backend environment e.g. public or usgovernment"
  type        = string
}

variable "deploy_environment" {
  description = "Name of the workload's environnement"
  type        = string
}

variable "workload_name" {
  description = "Name of the workload_name"
  type        = string
}

variable "org_name" {
  description = "Name of the organization"
  type        = string
}

#######################
# RG Configuration   ##
#######################

variable "create_resource_group" {
  description = "Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false."
  type        = bool
  default     = false
}

variable "use_location_short_name" {
  description = "Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored."
  type        = bool
  default     = true
}

variable "existing_resource_group_name" {
  description = "The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "enable_ampls" {
  description = "Enable Azure Monitor Private Link Scope"
  type        = bool
  default     = false
}

variable "ampls_subnet_address_prefix" {
  description = "The address prefix for the subnet to be created for Azure Monitor Private Link Scope."
  type        = list(string)
  default = null
}

variable "existing_virtual_network_name" {
  description = "(Required) Name of the virtual network for ampls"
  default = null
}

variable "existing_network_resource_group_name" {
  description = "(Required) Name of the resource group for ampls network"
  default = null
}



