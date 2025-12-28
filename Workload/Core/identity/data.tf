data "azurerm_subscription" "subscription" {
  subscription_id = var.subscription_id
}

# Data sources for managed identity principals
data "azurerm_user_assigned_identity" "managed_identities" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.principal_name => assignment
    if assignment.principal_type == "managed_identity"
  }

  name                = each.key
  resource_group_name = each.value.managed_identities_resource_group
}

# Data sources for user principals
data "azuread_user" "users" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.principal_name => assignment
    if assignment.principal_type == "user"
  }

  user_principal_name = each.key
}

# Data sources for service principal principals
data "azuread_service_principal" "service_principals" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.principal_name => assignment
    if assignment.principal_type == "service_principal"
  }

  display_name = each.key
}

# Data sources for resource group scopes
data "azurerm_resource_group" "resource_groups" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.resource_group => assignment
    if assignment.scope_type == "resource_group" && assignment.resource_group != null
  }

  name = each.key
}

# Data sources for key vault scopes
data "azurerm_key_vault" "key_vaults" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.scope_name => assignment
    if assignment.scope_type == "key_vault"
  }

  name                = each.key
  resource_group_name = each.value.scope_resource_group
}

# Data sources for storage account scopes
data "azurerm_storage_account" "storage_accounts" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.scope_name => assignment
    if assignment.scope_type == "storage_account"
  }

  name                = each.key
  resource_group_name = each.value.scope_resource_group
}