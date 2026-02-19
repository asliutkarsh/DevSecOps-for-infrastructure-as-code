# Resource Group
module "resource_group" {
  source                  = "../../../../Modules/resource_group"
  resource_group_name     = local.resource_group_name
  resource_group_location = var.resource_group_location
  tags                    = local.common_tags
}

# Managed Identities
module "managed_identity" {
  for_each = var.managed_identities

  source                      = "../../../../Modules/user_managed_identity"
  user_assigned_identity_name = local.identity_names[each.key]
  resource_group_name         = local.resource_group_name
  location                    = var.resource_group_location
  federated_credentials       = each.value.federated_credentials

  depends_on = [module.resource_group]
}
