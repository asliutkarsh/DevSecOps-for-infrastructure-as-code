variable "route_table_name" {
  type        = string
  description = "Name of the route table"
}

variable "route_table_location" {
  type        = string
  description = "Location of the route table"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "route_table_tags" {
  type        = map(string)
  default     = {}
  description = "Tags for route table"
}

variable "routes" {
  type = map(object({
    name                = string
    address_prefix      = string
    next_hop_type       = string
    next_hop_ip_address = optional(string, null)
  }))
  description = "Map of routes to create in the route table"
  default     = {}
}