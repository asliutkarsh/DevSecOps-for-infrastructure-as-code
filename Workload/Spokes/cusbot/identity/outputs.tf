output "resource_group_name" {
  description = "Name of the identity resource group"
  value       = module.resource_group.resource_group_name
}

output "resource_group_id" {
  description = "ID of the identity resource group"
  value       = module.resource_group.resource_group_id
}

output "managed_identity_ids" {
  description = "Map of managed identity IDs"
  value = {
    for key in keys(var.managed_identities) : key => module.managed_identity[key].user_assigned_identity_id
  }
}

output "managed_identity_principal_ids" {
  description = "Map of managed identity principal IDs"
  value = {
    for key in keys(var.managed_identities) : key => module.managed_identity[key].user_assigned_identity_principal_id
  }
}

output "managed_identity_client_ids" {
  description = "Map of managed identity client IDs"
  value = {
    for key in keys(var.managed_identities) : key => module.managed_identity[key].user_assigned_identity_client_id
  }
}
