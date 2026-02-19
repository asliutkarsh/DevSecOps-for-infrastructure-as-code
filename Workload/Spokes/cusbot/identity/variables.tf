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

variable "instance" {
  type        = string
  description = "Instance number (01, 02, etc.)"
  default     = "01"
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

variable "managed_identities" {
  type = map(object({
    custom_name = optional(string, "")
    federated_credentials = optional(map(object({
      name     = string
      audience = list(string)
      issuer   = string
      subject  = string
    })), {})
  }))
  description = "Map of managed identities to create. Each key becomes part of the identity name."
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to merge with common tags"
}
