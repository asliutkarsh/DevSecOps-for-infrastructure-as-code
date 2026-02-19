resource "azurerm_role_assignment" "rbac" {
  role_definition_name = var.role_definition_name
  scope                = var.scope
  principal_id         = var.principal_id

  description = var.description
}