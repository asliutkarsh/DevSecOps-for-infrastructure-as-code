output "resource_group_name" {
  description = "Name of the data resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "ID of the data resource group"
  value       = module.resource_group.resource_group_id
}

output "storage_account_ids" {
  description = "Map of storage account IDs"
  value = {
    for k, v in module.storage_account : k => v.storage_account_id
  }
}

output "storage_account_names" {
  description = "Map of storage account names"
  value       = local.storage_account_names
}

output "key_vault_ids" {
  description = "Map of Key Vault IDs"
  value = {
    for k, v in module.key_vault : k => v.key_vault_id
  }
}

output "key_vault_uris" {
  description = "Map of Key Vault URIs"
  value = {
    for k, v in module.key_vault : k => v.key_vault_uri
  }
}

output "key_vault_names" {
  description = "Map of Key Vault names"
  value       = local.key_vault_names
}

output "cosmos_account_ids" {
  description = "Map of Cosmos DB account IDs"
  value = {
    for k, v in module.cosmos_db : k => v.cosmos_account_id
  }
}

output "cosmos_account_endpoints" {
  description = "Map of Cosmos DB account endpoints"
  value = {
    for k, v in module.cosmos_db : k => v.cosmos_account_endpoint
  }
}

output "cosmos_account_names" {
  description = "Map of Cosmos DB account names"
  value       = local.cosmos_db_names
}
