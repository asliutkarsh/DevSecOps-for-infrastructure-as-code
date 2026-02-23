variable "org" {
  type        = string
  description = "Organization identifier"
  default     = "ajfc"
}

variable "project" {
  type        = string
  description = "Project code (max 6 chars)"

  validation {
    condition     = length(var.project) <= 6
    error_message = "Project code must be 6 characters or less."
  }
}

variable "environment" {
  type        = string
  description = "Environment (dev, uat, prod)"

  validation {
    condition     = contains(["dev", "uat", "prod"], var.environment)
    error_message = "Environment must be dev, uat, or prod."
  }
}

variable "location_code" {
  type        = string
  description = "Azure region short code (cin, eus, weu)"
  default     = "cin"
}

variable "app_owner_name" {
  type        = string
  description = "Team or individual owning this resource"
}

variable "resource_group_location" {
  type        = string
  description = "Full Azure region name"
  default     = "centralindia"
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to merge with common tags"
}

# Storage Accounts
variable "storage_accounts" {
  description = "Map of storage account configurations"
  type = map(object({
    tier                            = optional(string, "Standard")
    replication_type                = optional(string, "LRS")
    public_network_access_enabled   = optional(bool, false)
    is_hns_enabled                  = optional(bool, false)
    allow_nested_items_to_be_public = optional(bool, false)
    blob_versioning_enabled         = optional(bool, true)
    custom_name                     = optional(string, "")
  }))
  default = {}
}

# Key Vaults
variable "key_vaults" {
  description = "Map of key vault configurations"
  type = map(object({
    sku_name                   = optional(string, "standard")
    soft_delete_retention_days = optional(number, 7)
    purge_protection_enabled   = optional(bool, false)
    enable_rbac_authorization  = optional(bool, true)
    custom_name                = optional(string, "")
  }))
  default = {}
}

# Cosmos DBs
variable "cosmos_dbs" {
  description = "Map of cosmos db configurations"
  type = map(object({
    kind                          = optional(string, "GlobalDocumentDB")
    consistency_level             = optional(string, "Session")
    offer_type                    = optional(string, "Standard")
    public_network_access_enabled = optional(bool, false)
    free_tier_enabled             = optional(bool, false)
    custom_name                   = optional(string, "")
    geo_locations = optional(list(object({
      location          = string
      failover_priority = number
    })), [])
  }))
  default = {}
}
