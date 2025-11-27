variable "storage_account_name" {
  type        = string
  description = "Name of the storage account."
}

variable "storage_account_location" {
  type        = string
  description = "Location of the storage account."
}

variable "storage_account_resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "storage_account_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the storage account if not provided then empty map will be used."
}

variable "storage_account_tier" {
  type        = string
  description = "The performance tier for the storage account."
  validation {
    condition = var.storage_account_tier == "Standard" || var.storage_account_tier == "Premium"
    error_message = "The storage account tier must be Standard or Premium."
  }
}

variable "storage_account_replication_type" {
  type        = string
  description = "The replication type for the storage account."
  validation {
    condition = var.storage_account_replication_type == "LRS" || var.storage_account_replication_type == "GRS" || var.storage_account_replication_type == "RAGRS" || var.storage_account_replication_type == "ZRS" || var.storage_account_replication_type == "RAZRS"
    error_message = "The storage account replication type must be LRS, GRS, RAGRS, ZRS, or RAZRS."
  }
}

variable "public_network_access_enabled" {
  type        = bool
  description = "The public network access enabled for the storage account."
}

variable "is_hns_enabled" {
  type        = bool
  description = "The is HNS enabled for the storage account."
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  description = "The allow nested items to be public for the storage account."
}
