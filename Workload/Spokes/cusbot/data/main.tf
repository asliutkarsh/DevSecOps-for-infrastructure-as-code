# Resource Group
module "resource_group" {
  source                  = "../../../../Modules/resource_group"
  resource_group_name     = local.resource_group_name
  resource_group_location = var.resource_group_location
  tags                    = local.common_tags
}

# Storage Accounts
module "storage_account" {
  for_each = var.storage_accounts

  source                              = "../../../../Modules/storage/storage_account"
  storage_account_name                = local.storage_account_names[each.key]
  storage_account_location            = var.resource_group_location
  storage_account_resource_group_name = local.resource_group_name
  storage_account_tier                = each.value.tier
  storage_account_replication_type    = each.value.replication_type
  public_network_access_enabled       = each.value.public_network_access_enabled
  is_hns_enabled                      = each.value.is_hns_enabled
  allow_nested_items_to_be_public     = each.value.allow_nested_items_to_be_public
  blob_versioning_enabled             = each.value.blob_versioning_enabled
  storage_account_tags                = local.common_tags

  depends_on = [module.resource_group]
}

# Key Vaults
module "key_vault" {
  for_each = var.key_vaults

  source                     = "../../../../Modules/data/key_vault"
  key_vault_name             = local.key_vault_names[each.key]
  location                   = var.resource_group_location
  resource_group_name        = local.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = each.value.sku_name
  soft_delete_retention_days = each.value.soft_delete_retention_days
  purge_protection_enabled   = each.value.purge_protection_enabled
  rbac_authorization_enabled = each.value.enable_rbac_authorization
  key_vault_tags             = local.common_tags

  depends_on = [module.resource_group]
}

# Cosmos DBs
module "cosmos_db" {
  for_each = var.cosmos_dbs

  source = "../../../../Modules/data/cosmos_db"

  cosmos_account_name           = local.cosmos_db_names[each.key]
  location                      = var.resource_group_location
  resource_group_name           = local.resource_group_name
  offer_type                    = each.value.offer_type
  kind                          = each.value.kind
  consistency_level             = each.value.consistency_level
  public_network_access_enabled = each.value.public_network_access_enabled
  enable_free_tier              = each.value.free_tier_enabled
  cosmos_db_tags                = local.common_tags

  geo_locations = length(each.value.geo_locations) > 0 ? each.value.geo_locations : [
    {
      location          = var.resource_group_location
      failover_priority = 0
    }
  ]

  depends_on = [module.resource_group]
}
