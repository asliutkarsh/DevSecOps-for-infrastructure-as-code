locals {
  resource_group_name = "rg-${var.tenant_name}-${var.app_name}-${var.environment}-identity"

  identities_map = { for item in var.identities : item.identity_suffix => item }

  role_definition_name_per_identity = {
    for suffix, item in local.identities_map :
    suffix => lookup(item, "role_definition_name", null)
    if lookup(item, "role_definition_name", null) != null
  }

  federated_credentials_per_identity = {
    for suffix, item in local.identities_map :
    suffix => { for cred in item.federated_credentials : cred.name => cred }
    if length(item.federated_credentials) > 0
  }

  identity_names = { for suffix in keys(local.identities_map) :
    suffix => "id-${var.app_name}-${var.environment}-${suffix}"
  }

  common_tags = merge(var.tags, {
    Environment  = var.environment
    Project      = var.app_name
    AppOwnerName = var.app_owner_name
  })
}
