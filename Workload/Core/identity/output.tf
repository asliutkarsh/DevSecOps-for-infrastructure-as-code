output "resource_group_id" {
  value = module.resource_group.resource_group_id
}

output "user_assigned_identity_id" {
  description = "Map of user-assigned identity IDs keyed by identity suffix"
  value       = { for k, m in module.user_assigned_identity : k => m.user_assigned_identity_id }
}

output "user_assigned_identity_principal_id" {
  description = "Map of user-assigned identity principal IDs keyed by identity suffix"
  value       = { for k, m in module.user_assigned_identity : k => m.user_assigned_identity_principal_id }
}

output "user_assigned_identity_client_id" {
  description = "Map of user-assigned identity client IDs keyed by identity suffix"
  value       = { for k, m in module.user_assigned_identity : k => m.user_assigned_identity_client_id }
}
