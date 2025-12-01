module "resource_group" {
  source                  = "../../../Modules/resource_group"
  resource_group_name     = local.resource_group_name
  resource_group_location = var.resource_group_location
  tags                    = local.common_tags
}

module "user_assigned_identity" {
  source                      = "../../../Modules/user_managed_identity"
  for_each                    = local.identities_map
  location                    = var.resource_group_location
  resource_group_name         = local.resource_group_name
  user_assigned_identity_name = local.identity_names[each.key]
  federated_credentials       = lookup(local.federated_credentials_per_identity, each.key, {})
  depends_on                  = [module.resource_group]
}

module "role_assignment" {
  source               = "../../../Modules/role_assignment"
  for_each             = local.role_definition_name_per_identity
  scope                = module.user_assigned_identity[each.key].user_assigned_identity_id
  role_definition_name = each.value
  principal_id         = module.user_assigned_identity[each.key].user_assigned_identity_principal_id
  depends_on           = [module.user_assigned_identity]
}
