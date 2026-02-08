variable "tenant_name" {
  type        = string
  description = "Tenant Name"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID"
}

variable "app_owner_name" {
  type        = string
  description = "Application Owner Name"
}

variable "environment" {
  type        = string
  description = "Environment Name"
}

variable "resource_group_location" {
  type        = string
  description = "Resource Group Location"
}

variable "location_code" {
  type        = string
  description = "Location code for Azure region (e.g., cin, eus)"
}

variable "vnet_config" {
  type = object({
    address_space = list(string)
    dns_servers   = list(string)
  })
  description = "Virtual network configuration"
}

variable "subnet_nsg_rule_map" {
  type = map(list(object({
    name     = string
    priority = optional(number)
  })))
  description = "Map of subnet keys to list of NSG rule configurations. Each rule can override the default priority."
  default     = {}
}

# variable "default_nsg_rules" {
#   type = list(object({
#     name     = string
#     priority = optional(number)
#   }))
#   description = "Default NSG rules applied to ALL subnets. Useful for compliance rules like logging."
#   default     = []
# }

# variable "subnet_route_map" {
#   type        = map(list(string))
#   description = "Map of subnet keys to list of route definition keys. Each subnet gets a route table with these routes."
#   default     = {}
# }

variable "route_tables" {
  type = map(object({
    routes = list(string)
    name   = optional(string, "")
  }))
  description = "Map of route table keys to their configurations. Allows sharing route tables across multiple subnets."
  default     = {}
}

# variable "subnet_route_associations" {
#   type        = map(string)
#   description = "Map of subnet keys to route table keys for association. Allows decoupling creation from association (Scenario 1)."
#   default     = {}
# }

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
    private_link_service_network_policies_enabled = optional(bool, null)
  }))
  description = <<EOF
    Map of subnet configurations.

  EOF
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}
