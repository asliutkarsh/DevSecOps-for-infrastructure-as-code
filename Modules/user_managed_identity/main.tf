resource "azurerm_user_assigned_identity" "user_assigned_identity" {
  location            = var.location
  name                = var.user_assigned_identity_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_federated_identity_credential" "federated_credential" {
  for_each            = var.federated_credentials
  name                = each.value.name
  resource_group_name = var.resource_group_name
  audience            = each.value.audience
  issuer              = each.value.issuer
  parent_id           = azurerm_user_assigned_identity.user_assigned_identity.id
  subject             = each.value.subject
  depends_on          = [azurerm_user_assigned_identity.user_assigned_identity]
}
