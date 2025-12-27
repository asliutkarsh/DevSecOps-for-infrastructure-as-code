locals {
  resource_group_name = "rg-${var.tenant_name}-hub-${var.location_code}-identity-01"

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
    suffix => "id-${var.tenant_name}-hub-${var.location_code}-${suffix}-01"
  }

common_tags = merge(var.tags, {
    Project     = "Hub"
    Environment = "Shared-Core"
    Owner       = var.app_owner_name
    ManagedBy  = "Terraform"
  })
}
