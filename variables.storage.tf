
variable "loganalytics_storage_account_kind" {
  description = "The Kind of log analytics storage account to create. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage"
  type        = string
  default     = "StorageV2"
}

variable "loganalytics_storage_account_tier" {
  description = "The Tier of log analytics storage account to create. Valid options are Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "loganalytics_storage_account_replication_type" {
  description = "The Replication Type of log analytics storage account to create. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
  default     = "GRS"
}
