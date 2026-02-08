variable "nsg_name" {
  type        = string
  description = "Name of the network security group"
}

variable "nsg_location" {
  type        = string
  description = "Location of the network security group"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "nsg_tags" {
  type        = map(string)
  default     = {}
  description = "Tags for NSG"
}

variable "nsg_rules" {
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
    destination_address_prefix = string
    destination_port_range     = string
    description                = string
  }))
  description = "Map of NSG rules to create"
  default     = {}
}