locals {
  resource_group_name = "rg-${var.tenant_name}-${var.app_name}-${var.environment}-data"

  clean_app = substr(var.app_name, 0, 10)
  clean_env = substr(var.environment, 0, 3)

  storage_account_name = lower("st${local.clean_app}${local.clean_env}data")

  standard_storage_tier = "Standard"
  storage_replication   = "LRS"
  standard_account_kind = "StorageV2"

  premium_storage_tier = "Premium"
  premium_account_kind = "FileStorage"

  public_network_access           = true
  is_hns_enabled                  = false
  allow_nested_items_to_be_public = false

  storage_container_name = "tfstate"
  container_access_type  = "private"

  common_tags = merge(var.tags, {
    Environment  = var.environment
    Project      = var.app_name
    AppOwnerName = var.app_owner_name
  })

}
