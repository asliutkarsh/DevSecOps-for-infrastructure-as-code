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

variable "vnet_config" {
  type = object({
    address_space = list(string)
    dns_servers   = list(string)
  })
  description = "Virtual network configuration"
}

variable "subnets_config" {
  type = map(object({
    address_prefix  = string
    use_subnet_name = bool
    custom_name     = optional(string, "")
    route_table_key = optional(string, "")
    delegation = optional(object({
      name                    = string
      service_delegation_name = string
      actions                 = optional(list(string), [])
    }), null)
    private_endpoint_network_policies             = optional(string, "Disabled")
    service_endpoints                             = optional(list(string), null)
    private_link_service_network_policies_enabled = optional(bool, false)
  }))
  description = "Map of subnet configurations. Keys: compute, aks, pe."
}

variable "subnet_nsg_rule_map" {
  type = map(list(object({
    name     = string
    priority = optional(number)
  })))
  description = "Map of subnet keys to list of NSG rule configurations. NSGs created for compute and pe subnets."
  default     = {}
}

variable "route_tables" {
  type = map(object({
    routes = list(string)
    name   = optional(string, "")
  }))
  description = "Map of route table keys to their configurations. Route tables for compute and aks subnets."
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to merge with common tags"
}
