variable "scope" {
  description = "(Required) The scope at which the Role Assignment applies to."
  type        = string
}

variable "role_definition_name" {
  description = "(Required) The name of a built-in Role."
  type        = string
}

variable "principal_id" {
  description = "(Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to."
  type        = string
}

variable "description" {
  description = "(Optional) The description for this role assignment."
  type        = string
  default     = null
}

variable "assignment_name" {
  description = "(Optional) A unique UUID/GUID for this Role Assignment. One will be generated if not specified."
  type        = string
  default     = null
}