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
    federated_credentials = optional(list(object({
      name     = string
      audience = list(string)
      issuer   = string
      subject  = string
    })), [])
  }))

  description = <<EOF
    List of managed identities with their federated credentials.
    Each identity has an identity_suffix used to generate the identity name.
    Each identity can optionally have multiple federated credentials.

    Example:

    identities = [
      {
        identity_suffix = "github-terraform"
        federated_credentials = [
          {
            name     = "main"
            audience = ["api://AzureADTokenExchange"]
            issuer   = "https://token.actions.githubusercontent.com"
            subject  = "repo:org/repo:ref:refs/heads/main"
          }
        ]
      }
    ]
    EOF
}

variable "rbac_assignments" {
  type = map(object({
    principal_type                    = string
    principal_name                    = string
    role_name                         = string
    scope_type                        = string
    scope_name                        = string
    scope_resource_group              = optional(string)
    managed_identities_resource_group = optional(string)
    description                       = optional(string)
  }))

  description = <<EOF
    Map of RBAC assignments with secure runtime resolution.
    Principals and scopes are resolved by name at runtime, not by ID.

    principal_type: "managed_identity" | "user" | "service_principal"
    scope_type: "subscription" | "resource_group" | "key_vault" | "storage_account"

    Example:

    rbac_assignments = {
      "github_terraform_vault_access" = {
        principal_type = "managed_identity"
        principal_name = "id-ajfc-hub-cin-github-terraform-01"
        role_name      = "Key Vault Secrets User"
        scope_type     = "key_vault"
        scope_name     = "kv-ajfc-hub-cin-data-01"
        scope_resource_group = "rg-ajfc-hub-cin-data-01"
        managed_identities_resource_group = "rg-ajfc-hub-cin-core-01"
        description    = "CI/CD pipeline access to Hub Key Vault secrets"
      },
      
      "admin_user_subscription_access" = {
        principal_type = "user"
        principal_name = "admin@ajfc.com"
        role_name      = "Owner"
        scope_type     = "subscription"
        scope_name     = "subscription"
        description    = "Admin user access to subscription"
      }
    }
    EOF

  validation {
    condition = alltrue([
      for assignment in values(var.rbac_assignments) : contains([
        "managed_identity", "user", "service_principal"
      ], assignment.principal_type)
    ])
    error_message = "principal_type must be one of: managed_identity, user, service_principal."
  }

  validation {
    condition = alltrue([
      for assignment in values(var.rbac_assignments) : contains([
        "subscription", "resource_group", "key_vault", "storage_account"
      ], assignment.scope_type)
    ])
    error_message = "scope_type must be one of: subscription, resource_group, key_vault, storage_account."
  }

  validation {
    condition = alltrue([
      for assignment in values(var.rbac_assignments) :
      assignment.scope_type == "subscription" ||
      (assignment.scope_type != "subscription" && assignment.scope_resource_group != null)
    ])
    error_message = "scope_resource_group is required for all scope_types except 'subscription'. Please provide the resource group name for the scope."
  }

  validation {
    condition = alltrue([
      for assignment in values(var.rbac_assignments) :
      assignment.principal_type != "managed_identity" ||
      (assignment.principal_type == "managed_identity" && assignment.managed_identities_resource_group != null)
    ])
    error_message = "managed_identities_resource_group is required when principal_type is 'managed_identity'. Please provide the resource group name for the managed identity."
  }
}
