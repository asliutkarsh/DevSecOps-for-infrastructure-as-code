output "user_assigned_identity_id" {
  value = azurerm_user_assigned_identity.user_assigned_identity.id
}

output "user_assigned_identity_principal_id" {
  value = azurerm_user_assigned_identity.user_assigned_identity.principal_id
}

output "user_assigned_identity_client_id" {
  value = azurerm_user_assigned_identity.user_assigned_identity.client_id
}
