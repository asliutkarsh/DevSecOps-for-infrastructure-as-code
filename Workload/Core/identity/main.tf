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
  federated_credentials       = local.federated_credentials_per_identity[each.key]

  depends_on = [ module.resource_group ]
}
