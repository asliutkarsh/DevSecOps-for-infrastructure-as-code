locals {
  resource_group_name = "rg-${var.tenant_name}-hub-${var.location_code}-data-01"

  storage_account_name = lower("st${var.tenant_name}hub${var.location_code}data01")

  standard_storage_tier = "Standard"
  storage_replication   = "LRS"
  standard_account_kind = "StorageV2"

  premium_storage_tier = "Premium"
  premium_account_kind = "FileStorage"

  public_network_access           = true
  is_hns_enabled                  = false
  allow_nested_items_to_be_public = false
  blob_versioning_enabled         = true

  storage_container_name = "tfstate"
  container_access_type  = "private"

common_tags = merge(var.tags, {
    Project     = "Hub"
    Environment = "Shared-Core"
    Owner       = var.app_owner_name
    ManagedBy  = "Terraform"
  })

}
