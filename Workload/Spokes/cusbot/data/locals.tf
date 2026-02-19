locals {
  # Spoke naming: rg-ajfc-custbot-dev-cin-data-01
  resource_group_name = "rg-${var.org}-${var.project}-${var.environment}-${var.location_code}-data-01"

  # Storage Account Names
  storage_account_names = {
    for key, config in var.storage_accounts : key =>
    config.custom_name != "" ? config.custom_name : "st${var.org}${var.project}${var.environment}${var.location_code}${key}01"
  }

  # Key Vault Names
  key_vault_names = {
    for key, config in var.key_vaults : key =>
    config.custom_name != "" ? config.custom_name : "kv${var.org}${var.project}${var.environment}${var.location_code}${key}01"
  }

  # Cosmos DB Names
  cosmos_db_names = {
    for key, config in var.cosmos_dbs : key =>
    config.custom_name != "" ? config.custom_name : "cosmos-${var.org}-${var.project}-${var.environment}-${var.location_code}-${key}-01"
  }

  common_tags = merge(var.tags, {
    Project     = var.project
    Environment = title(var.environment)
    Owner       = var.app_owner_name
    ManagedBy   = "Terraform"
  })
}
