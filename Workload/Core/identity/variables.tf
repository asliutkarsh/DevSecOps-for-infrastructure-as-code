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
  description = "Application Name - Eg: ChatApp"
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

variable "location_code" {
  type        = string
  description = "Location code for Azure region (e.g., cin, eus)"
}

variable "tags" {
  type        = map(string)
  description = "Common Tags"
  default     = {}
}

variable "identities" {
  type = list(object({
    identity_suffix = string
    role_definition_name  = optional(string)
    federated_credentials = optional(list(object({
      name     = string
      audience = list(string)
      issuer   = string
      subject  = string
    })), [])
  }))

  description = <<EOF
    List of identities with their federated credentials.
    Each identity has an identity_suffix used to generate the identity name.
    Each identity can optionally have multiple federated credentials.

    Example:

    identities = [
      {
        identity_suffix = "github"
        role_definition_name = "Storage Blob Data Contributor"
        federated_credentials = [
          {
            name     = "main"
            audience = ["api://AzureADTokenExchange"]
            issuer   = "https://token.actions.githubusercontent.com"
            subject  = "repo:org/repo:ref:refs/heads/main"
          },
          {
            name     = "ci"
            audience = ["api://AzureADTokenExchange"]
            issuer   = "https://token.actions.githubusercontent.com"
            subject  = "repo:org/repo:workflow:ci.yml"
          }
        ]
      },
      {
        identity_suffix = "empty-id"  # identity with no federated credentials
        # federated_credentials can be omitted or left empty
      }
    ]
    EOF
}
