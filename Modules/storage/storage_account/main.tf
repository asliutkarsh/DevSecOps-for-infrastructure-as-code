resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.storage_account_resource_group_name
  location                 = var.storage_account_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  public_network_access_enabled = var.public_network_access_enabled

  is_hns_enabled                  = var.is_hns_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  blob_properties {
    versioning_enabled = var.blob_versioning_enabled
  }

  tags = var.storage_account_tags
}
