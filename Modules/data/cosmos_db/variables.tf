variable "cosmos_account_name" {
  type        = string
  description = "Name of the Cosmos DB account."
}

variable "location" {
  type        = string
  description = "Azure region where the Cosmos DB account will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to place the Cosmos DB account in."
}

variable "offer_type" {
  type        = string
  description = "Cosmos DB offer type. Currently only Standard is supported."
  default     = "Standard"
}

variable "kind" {
  type        = string
  description = "Kind of Cosmos DB account (GlobalDocumentDB or MongoDB)."
  default     = "GlobalDocumentDB"

  validation {
    condition     = contains(["GlobalDocumentDB", "MongoDB"], var.kind)
    error_message = "Cosmos DB kind must be GlobalDocumentDB or MongoDB."
  }
}

variable "consistency_level" {
  type        = string
  description = "Cosmos DB consistency level."
  default     = "Session"

  validation {
    condition = contains(
      ["Strong", "BoundedStaleness", "Session", "ConsistentPrefix", "Eventual"],
      var.consistency_level
    )
    error_message = "Invalid consistency level."
  }
}

variable "max_interval_in_seconds" {
  type        = number
  description = "Max interval in seconds for BoundedStaleness consistency. Required when consistency_level is BoundedStaleness."
  default     = 5
}

variable "max_staleness_prefix" {
  type        = number
  description = "Max staleness prefix for BoundedStaleness consistency. Required when consistency_level is BoundedStaleness."
  default     = 100
}

variable "geo_locations" {
  type = list(object({
    location          = string
    failover_priority = number
  }))
  description = "List of geo-locations for the Cosmos DB account. At least one (primary) is required."
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Enable public network access for the Cosmos DB account."
  default     = false
}

variable "enable_free_tier" {
  type        = bool
  description = "Enable free tier for the Cosmos DB account."
  default     = false
}

variable "cosmos_db_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Cosmos DB account."
}
