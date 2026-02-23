# Project Configuration
org            = "ajfc"
project        = "cusbot"
environment    = "dev"
location_code  = "cin"
app_owner_name = "AI Bot Team"

# Azure Configuration
resource_group_location = "centralindia"

# Storage Accounts
storage_accounts = {
  data = {
    tier                            = "Standard"
    replication_type                = "LRS"
    public_network_access_enabled   = false
    is_hns_enabled                  = false
    allow_nested_items_to_be_public = false
    blob_versioning_enabled         = false
  }
}

# Key Vaults
key_vaults = {
  data = {
    sku_name                   = "standard"
    soft_delete_retention_days = 7
    purge_protection_enabled   = false
    enable_rbac_authorization  = true
  }
  #   with custom name if you want to use it 
  #   ,
  #   secrets = {
  #     custom_name                = "kvajfccusbotdevcinsec01"
  #     sku_name                   = "standard"
  #     soft_delete_retention_days = 7
  #     purge_protection_enabled   = false
  #     enable_rbac_authorization  = true
  #   }
}

# Cosmos DBs
cosmos_dbs = {
  data = {
    kind                          = "GlobalDocumentDB"
    consistency_level             = "Session"
    public_network_access_enabled = false
    free_tier_enabled             = true
    geo_locations                 = []
  }
}
