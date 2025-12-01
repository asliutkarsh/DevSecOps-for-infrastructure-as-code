locals {
  resource_group_name = "rg-${var.tenant_name}-${var.app_name}-${var.environment}-identity"

  clean_app = substr(var.app_name, 0, 10)
  clean_env = substr(var.environment, 0, 3)

  identities_map = {
    for item in var.identities :
    item.identity_suffix => item
  }

  federated_credentials_per_identity = {
    for suffix, item in local.identities_map :
    suffix => {
      for cred in item.federated_credentials : cred.name => cred
      if length(item.federated_credentials) > 0
    }
  }

  identity_names = {
    for suffix in keys(local.identities_map) :
    suffix => "id-${var.app_name}-${var.environment}-${suffix}"
  }



  common_tags = merge(var.tags, {
    Environment  = var.environment
    Project      = var.app_name
    AppOwnerName = var.app_owner_name
  })

}
