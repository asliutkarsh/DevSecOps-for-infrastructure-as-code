variable "resource_group_location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the resource group if not provided then empty map will be used."
}