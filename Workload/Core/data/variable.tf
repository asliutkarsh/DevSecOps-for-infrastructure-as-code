variable "tenant_name" {
  type        = string
  description = "Tenant Name"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID"
}

variable "app_name" {
  type        = string
  description = "Application Name - Eg: "
}

variable "app_owner_name" {
  type        = string
  description = "Application Owner Name"
}

variable "environment" {
  type        = string
  description = "Environment Name - Eg: Core"
}

variable "resource_group_location" {
  type        = string
  description = "Resource Group Location"
}

variable "tags" {
  type        = map(string)
  description = "Common Tags"
  default     = {}
}