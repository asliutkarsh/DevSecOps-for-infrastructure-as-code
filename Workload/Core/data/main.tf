module "resource_group" {
  source                  = "../../../Modules/resource_group"
  resource_group_name     = local.resource_group_name
  resource_group_location = var.resource_group_location
  tags                    = local.common_tags
}

module "storage_account" {
  source                              = "../../../Modules/storage/storage_account"
  storage_account_name                = local.storage_account_name
  storage_account_resource_group_name = local.resource_group_name
  storage_account_tier                = local.standard_storage_tier
  storage_account_location            = var.resource_group_location
  storage_account_replication_type    = local.storage_replication
  public_network_access_enabled       = local.public_network_access
  is_hns_enabled                      = local.is_hns_enabled
  allow_nested_items_to_be_public     = local.allow_nested_items_to_be_public
  storage_account_tags                = local.common_tags

  depends_on = [module.resource_group]
}

module "container" {
  source = "../../../Modules/storage/container"

  storage_container_name = local.storage_container_name
  container_access_type  = local.container_access_type
  storage_account_id     = module.storage_account.storage_account_id

  depends_on = [module.storage_account]
}