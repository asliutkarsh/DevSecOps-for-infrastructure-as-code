variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault."
}

variable "location" {
  type        = string
  description = "Azure region where the Key Vault will be created."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to place the Key Vault in."
}

variable "tenant_id" {
  type        = string
  description = "Azure Active Directory tenant ID for the Key Vault."
}

variable "sku_name" {
  type        = string
  description = "SKU name for the Key Vault (standard or premium)."
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "Key Vault SKU must be standard or premium."
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain soft-deleted keys, secrets, and certificates."
  default     = 7

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention must be between 7 and 90 days."
  }
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Enable purge protection to prevent permanent deletion during retention period."
  default     = false
}

variable "rbac_authorization_enabled" {
  type        = bool
  description = "Enable Azure RBAC authorization for the Key Vault instead of access policies."
  default     = true
}

variable "key_vault_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Key Vault."
}

variable "access_policy" {
  type = list(object({
    tenant_id           = string
    object_id           = string
    key_permissions     = list(string)
    secret_permissions  = list(string)
    storage_permissions = list(string)
  }))
  default     = []
  description = "Access policies for the Key Vault."
}
