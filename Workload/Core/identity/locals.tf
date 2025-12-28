locals {
  resource_group_name = "rg-${var.tenant_name}-hub-${var.location_code}-identity-01"

  identities_map = { for item in var.identities : item.identity_suffix => item }

  identity_names = {
    for suffix in keys(local.identities_map) :
    suffix => "id-${var.tenant_name}-hub-${var.location_code}-${suffix}-01"
  }

  federated_credentials_per_identity = {
    for suffix, item in local.identities_map :
    suffix => { for cred in item.federated_credentials : cred.name => cred }
    if length(item.federated_credentials) > 0
  }

  # RBAC Assignment
  # We will get the principal IDs and types from the data sources
  resolved_principals = {
    for key, assignment in var.rbac_assignments : key => {
      principal_id = (assignment.principal_type == "managed_identity"
        ? data.azurerm_user_assigned_identity.managed_identities[assignment.principal_name].principal_id
        : assignment.principal_type == "user"
        ? data.azuread_user.users[assignment.principal_name].object_id
        : assignment.principal_type == "service_principal"
        ? data.azuread_service_principal.service_principals[assignment.principal_name].object_id
      : null)
      principal_type = assignment.principal_type
      principal_name = assignment.principal_name
    }
  }


  # Scope resolution
  # We will get the scope IDs from the data sources
  resolved_scopes = {
    for key, assignment in var.rbac_assignments : key => {
      scope_id = (assignment.scope_type == "subscription"
        ? data.azurerm_subscription.subscription.id
        : assignment.scope_type == "resource_group"
        ? data.azurerm_resource_group.resource_groups[assignment.resource_group].id
        : assignment.scope_type == "key_vault"
        ? data.azurerm_key_vault.key_vaults[assignment.scope_name].id
        : assignment.scope_type == "storage_account"
        ? data.azurerm_storage_account.storage_accounts[assignment.scope_name].id
      : null)
      scope_type = assignment.scope_type
      scope_name = assignment.scope_name
    }
  }

  # Validation checks
  # We will validate that all principals and scopes exist
  validation_errors = concat(
    [
      for key, assignment in var.rbac_assignments :
      "RBAC assignment '${key}': Principal '${assignment.principal_name}' of type '${assignment.principal_type}' not found"
      if local.resolved_principals[key].principal_id == null
    ],
    [
      for key, assignment in var.rbac_assignments :
      "RBAC assignment '${key}': Scope '${assignment.scope_name}' of type '${assignment.scope_type}' not found"
      if local.resolved_scopes[key].scope_id == null
    ]
  )

  # Final resolved RBAC assignments (only valid ones)
  # We will only include assignments where both principal and scope are found and valid
  resolved_rbac_assignments = {
    for key, assignment in var.rbac_assignments : key => {
      principal_id   = local.resolved_principals[key].principal_id
      principal_type = local.resolved_principals[key].principal_type
      principal_name = local.resolved_principals[key].principal_name
      role_name      = assignment.role_name
      scope_id       = local.resolved_scopes[key].scope_id
      scope_type     = local.resolved_scopes[key].scope_type
      scope_name     = local.resolved_scopes[key].scope_name
      description    = lookup(assignment, "description", null)
    }
    if local.resolved_principals[key].principal_id != null && local.resolved_scopes[key].scope_id != null && length(local.validation_errors) == 0
  }

  # Common tags
  common_tags = merge(var.tags, {
    Project     = "Hub"
    Environment = "Shared-Core"
    Owner       = var.app_owner_name
    ManagedBy   = "Terraform"
  })
}
