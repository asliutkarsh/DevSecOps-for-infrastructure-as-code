# Resource Group for Identity Components
module "resource_group" {
  source                  = "../../../Modules/resource_group"
  resource_group_name     = local.resource_group_name
  resource_group_location = var.resource_group_location
  tags                    = local.common_tags
}

# Managed Identities
module "user_assigned_identity" {
  source                      = "../../../Modules/user_managed_identity"
  for_each                    = local.identities_map
  location                    = var.resource_group_location
  resource_group_name         = local.resource_group_name
  user_assigned_identity_name = local.identity_names[each.key]
  federated_credentials       = lookup(local.federated_credentials_per_identity, each.key, {})
  depends_on                  = [module.resource_group]
}

# RBAC Assignments with Dynamic Resolution using Module
module "role_assignment" {
  for_each = local.resolved_rbac_assignments

  source               = "../../../Modules/role_assignment"
  scope                = each.value.scope_id
  role_definition_name = each.value.role_name
  principal_id         = each.value.principal_id
  description          = each.value.description != null ? each.value.description : "RBAC assignment for ${each.value.principal_type} ${each.value.principal_name} to ${each.value.scope_type} ${each.value.scope_name}"
  assignment_name      = each.key

  depends_on = [
    module.user_assigned_identity,
    data.azurerm_user_assigned_identity.managed_identities,
    data.azuread_user.users,
    data.azuread_service_principal.service_principals,
    data.azurerm_resource_group.resource_groups,
    data.azurerm_key_vault.key_vaults,
    data.azurerm_storage_account.storage_accounts
  ]
}
