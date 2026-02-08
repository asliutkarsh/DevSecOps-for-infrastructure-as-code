# RBAC Management System Documentation

## Overview

The RBAC Management System provides a secure, readable, and flexible approach to managing Azure Role-Based Access Control (RBAC) assignments using Terraform. This system implements a unified architecture that separates concerns between identity management and permission assignments while maintaining security through dynamic runtime resolution.

## Architecture

### Core Principles

1. **Security First**: No sensitive resource IDs exposed in configuration
2. **Human-Readable Configuration**: Use names instead of IDs for better auditability
3. **Dynamic Resolution**: Principals and scopes resolved at runtime via data sources
4. **Modular Design**: Clear separation between workload orchestration and resource definitions
5. **Validation-Driven**: Comprehensive validation at both variable and runtime levels

### Component Structure

```
Workload/Core/identity/
├── main.tf          # Module orchestration
├── variables.tf      # Input definitions with validation
├── locals.tf         # Resolution logic and processing
├── data.tf          # Dynamic resource discovery
└── outputs.tf       # Result exports

Modules/role_assignment/
├── main.tf          # Azure role assignment resource
├── variables.tf     # Module input parameters
└── outputs.tf       # Assignment outputs

Deployment/Core/identity/
└── identity.tfvars  # Human-readable configuration
```

## Configuration Structure

### 1. Managed Identities

Define Azure AD managed identities with federated credentials for external authentication:

```hcl
identities = [
  {
    identity_suffix = "github-terraform"
    federated_credentials = [
      {
        name     = "main"
        audience = ["api://AzureADTokenExchange"]
        issuer   = "https://token.actions.githubusercontent.com"
        subject  = "repo:org/repo:ref:refs/heads/main"
      }
    ]
  }
]
```

**Key Fields:**

- `identity_suffix`: Used to generate the full identity name following naming convention
- `federated_credentials`: OIDC federation configuration for external systems

### 2. RBAC Assignments

Define permission assignments using human-readable names:

```hcl
rbac_assignments = {
  "github_terraform_subscription_access" = {
    principal_type                    = "managed_identity"
    principal_name                    = "id-ajfc-hub-cin-github-terraform-01"
    role_name                         = "Owner"
    scope_type                        = "subscription"
    scope_name                        = "subscription"
    managed_identities_resource_group = "rg-ajfc-hub-cin-identity-01"
    description                       = "GitHub Actions Terraform identity with subscription owner access"
  }
}
```

**Principal Types:**

- `managed_identity`: Azure AD managed identity
- `user`: Azure AD user (by UPN)
- `service_principal`: Azure AD service principal

**Scope Types:**

- `subscription`: Subscription-level access
- `resource_group`: Resource group-level access
- `key_vault`: Key Vault-specific access
- `storage_account`: Storage account access

## Dynamic Resolution Process

### 1. Principal Resolution

The system dynamically resolves principal IDs using data sources:

```hcl
# Managed Identities
data "azurerm_user_assigned_identity" "managed_identities" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.principal_name => assignment
    if assignment.principal_type == "managed_identity"
  }
  name                = each.key
  resource_group_name = each.value.managed_identities_resource_group
}

# Users
data "azuread_user" "users" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.principal_name => assignment
    if assignment.principal_type == "user"
  }
  user_principal_name = each.key
}

# Service Principals
data "azuread_service_principal" "service_principals" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.principal_name => assignment
    if assignment.principal_type == "service_principal"
  }
  display_name = each.key
}
```

### 2. Scope Resolution

Scope IDs are resolved dynamically based on scope type:

```hcl
# Resource Groups
data "azurerm_resource_group" "resource_groups" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.resource_group => assignment
    if assignment.scope_type == "resource_group"
  }
  name = each.key
}

# Key Vaults
data "azurerm_key_vault" "key_vaults" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.scope_name => assignment
    if assignment.scope_type == "key_vault"
  }
  name                = each.key
  resource_group_name = each.value.scope_resource_group
}

# Storage Accounts
data "azurerm_storage_account" "storage_accounts" {
  for_each = {
    for assignment in var.rbac_assignments :
    assignment.scope_name => assignment
    if assignment.scope_type == "storage_account"
  }
  name                = each.key
  resource_group_name = each.value.scope_resource_group
}
```

### 3. Resolution Logic

The locals.tf file contains the core resolution logic:

```hcl
# Principal Resolution
resolved_principals = {
  for key, assignment in var.rbac_assignments : key => {
    principal_id = assignment.principal_type == "managed_identity" 
      ? data.azurerm_user_assigned_identity.managed_identities[assignment.principal_name].principal_id
      : assignment.principal_type == "user"
      ? data.azuread_user.users[assignment.principal_name].object_id
      : assignment.principal_type == "service_principal"
      ? data.azuread_service_principal.service_principals[assignment.principal_name].object_id
      : null
    principal_type = assignment.principal_type
    principal_name = assignment.principal_name
  }
}

# Scope Resolution
resolved_scopes = {
  for key, assignment in var.rbac_assignments : key => {
    scope_id = assignment.scope_type == "subscription"
      ? data.azurerm_subscription.subscription.id
      : assignment.scope_type == "resource_group"
      ? data.azurerm_resource_group.resource_groups[assignment.resource_group].id
      : assignment.scope_type == "key_vault"
      ? data.azurerm_key_vault.key_vaults[assignment.scope_name].id
      : assignment.scope_type == "storage_account"
      ? data.azurerm_storage_account.storage_accounts[assignment.scope_name].id
      : null
    scope_type = assignment.scope_type
    scope_name = assignment.scope_name
  }
}
```

## Validation System

### 1. Variable-Level Validation

Comprehensive validation rules ensure configuration integrity:

```hcl
# Principal Type Validation
validation {
  condition = alltrue([
    for assignment in values(var.rbac_assignments) : contains([
      "managed_identity", "user", "service_principal"
    ], assignment.principal_type)
  ])
  error_message = "principal_type must be one of: managed_identity, user, service_principal."
}

# Scope Type Validation
validation {
  condition = alltrue([
    for assignment in values(var.rbac_assignments) : contains([
      "subscription", "resource_group", "key_vault", "storage_account"
    ], assignment.scope_type)
  ])
  error_message = "scope_type must be one of: subscription, resource_group, key_vault, storage_account."
}

# Required Resource Group Validation
validation {
  condition = alltrue([
    for assignment in values(var.rbac_assignments) :
    assignment.scope_type == "subscription" ||
    (assignment.scope_type != "subscription" && assignment.scope_resource_group != null)
  ])
  error_message = "scope_resource_group is required for all scope_types except 'subscription'."
}
```

### 2. Runtime Validation

Dynamic validation checks for resource existence:

```hcl
# Validation Error Detection
validation_errors = concat(
  [
    for key, assignment in var.rbac_assignments : 
    "RBAC assignment '${key}': Principal '${assignment.principal_name}' of type '${assignment.principal_type}' not found"
    if local.resolved_principals[key].principal_id == null
  ],
  [
    for key, assignment in var.rbac_assignments : 
    "RBAC assignment '${key}': Scope '${assignment.scope_name}' of type '${assignment.scope_type}' not found"
    if local.resolved_scopes[key].scope_id == null
  ]
)

# Filter Valid Assignments Only
resolved_rbac_assignments = {
  for key in var.rbac_assignments : key => {
    principal_id   = local.resolved_principals[key].principal_id
    principal_type = local.resolved_principals[key].principal_type
    principal_name = local.resolved_principals[key].principal_name
    role_name      = var.rbac_assignments[key].role_name
    scope_id       = local.resolved_scopes[key].scope_id
    scope_type     = local.resolved_scopes[key].scope_type
    scope_name     = local.resolved_scopes[key].scope_name
    description    = lookup(var.rbac_assignments[key], "description", null)
  }
  if local.resolved_principals[key].principal_id != null && local.resolved_scopes[key].scope_id != null
}
```

## Module Integration

### Role Assignment Module

The role assignment module provides a clean interface for creating RBAC assignments:

```hcl
# Modules/role_assignment/main.tf
resource "azurerm_role_assignment" "rbac" {
  role_definition_name = var.role_definition_name
  scope                = var.scope
  principal_id         = var.principal_id
  description          = var.description
}
```

```hcl
# Modules/role_assignment/variables.tf
variable "scope" {
  description = "(Required) The scope at which the Role Assignment applies to."
  type        = string
}

variable "role_definition_name" {
  description = "(Required) The name of a built-in Role."
  type        = string
}

variable "principal_id" {
  description = "(Required) The ID of the Principal to assign the Role Definition to."
  type        = string
}

variable "description" {
  description = "(Optional) The description for this role assignment."
  type        = string
  default     = null
}
```

### Workload Integration

The identity workload orchestrates all components:

```hcl
# Resource Group
module "resource_group" {
  source                  = "../../../Modules/resource_group"
  resource_group_name     = local.resource_group_name
  resource_group_location = var.resource_group_location
  tags                    = local.common_tags
}

# Managed Identities
module "user_assigned_identity" {
  source                      = "../../../Modules/user_managed_identity"
  for_each                    = local.identities_map
  location                    = var.resource_group_location
  resource_group_name         = local.resource_group_name
  user_assigned_identity_name = local.identity_names[each.key]
  federated_credentials       = lookup(local.federated_credentials_per_identity, each.key, {})
  depends_on                  = [module.resource_group]
}

# RBAC Assignments
module "role_assignment" {
  for_each = local.resolved_rbac_assignments
  
  source               = "../../../Modules/role_assignment"
  scope                = each.value.scope_id
  role_definition_name = each.value.role_name
  principal_id         = each.value.principal_id
  description          = each.value.description
  
  depends_on = [
    module.user_assigned_identity,
    data.azurerm_user_assigned_identity.managed_identities,
    data.azuread_user.users,
    data.azuread_service_principal.service_principals,
    data.azurerm_resource_group.resource_groups,
    data.azurerm_key_vault.key_vaults,
    data.azurerm_storage_account.storage_accounts
  ]
}
```

## Security Features

### 1. No Sensitive Data Exposure

- **Configuration Security**: Resource IDs never appear in .tfvars files
- **Runtime Resolution**: All sensitive data resolved via data sources
- **Audit Trail**: Clear descriptions for business context

### 2. Principle of Least Privilege

- **Specific Roles**: Use built-in roles like "Key Vault Secrets User" instead of "Owner"
- **Scoped Access**: Assign permissions at the most restrictive level possible
- **Environment Isolation**: Different permissions per environment

### 3. Validation & Error Handling

- **Pre-deployment Validation**: Variable-level checks prevent invalid configurations
- **Runtime Validation**: Dynamic checks ensure resources exist
- **Error Filtering**: Only valid assignments are applied

## Usage Examples

### Example 1: GitHub Actions CI/CD

```hcl
rbac_assignments = {
  "github_terraform_vault_access" = {
    principal_type                    = "managed_identity"
    principal_name                    = "id-ajfc-hub-cin-github-terraform-01"
    role_name                         = "Key Vault Secrets User"
    scope_type                        = "key_vault"
    scope_name                        = "kv-ajfc-hub-cin-data-01"
    scope_resource_group              = "rg-ajfc-hub-cin-data-01"
    managed_identities_resource_group = "rg-ajfc-hub-cin-identity-01"
    description                       = "CI/CD pipeline access to Hub Key Vault secrets"
  }
}
```

### Example 2: Admin User Access

```hcl
rbac_assignments = {
  "admin_user_subscription_access" = {
    principal_type = "user"
    principal_name = "admin@ajfc.com"
    role_name      = "Owner"
    scope_type     = "subscription"
    scope_name     = "subscription"
    description    = "Admin user access to subscription"
  }
}
```

### Example 3: Service Principal Storage Access

```hcl
rbac_assignments = {
  "app_service_storage_access" = {
    principal_type = "service_principal"
    principal_name = "app-service-sp"
    role_name      = "Storage Blob Data Contributor"
    scope_type     = "storage_account"
    scope_name     = "stajfchubcindata01"
    scope_resource_group = "rg-ajfc-hub-cin-data-01"
    description    = "App Service access to storage account"
  }
}
```

## Best Practices

### 1. Naming Conventions

- **Assignment Keys**: Use descriptive, unique keys (e.g., "github_terraform_vault_access")
- **Identity Names**: Follow enterprise naming convention
- **Descriptions**: Provide business context for audit purposes

### 2. Role Selection

- **Prefer Built-in Roles**: Use Azure built-in roles when possible
- **Least Privilege**: Assign minimum required permissions
- **Role Consistency**: Use consistent role names across assignments

### 3. Scope Management

- **Most Restrictive Scope**: Assign permissions at the lowest possible level
- **Resource Group Requirements**: Always specify resource groups for resource-level scopes
- **Subscription Access**: Limit subscription-level access to administrators

### 4. Validation

- **Test Configurations**: Validate configurations before deployment
- **Error Handling**: Monitor validation errors during planning
- **Resource Existence**: Ensure referenced resources exist

## Troubleshooting

### Common Issues

1. **Principal Not Found**
   - **Cause**: Principal name or resource group incorrect
   - **Solution**: Verify principal exists in specified resource group

2. **Scope Not Found**
   - **Cause**: Scope name or resource group incorrect
   - **Solution**: Verify resource exists in specified resource group

3. **Validation Errors**
   - **Cause**: Missing required fields or invalid values
   - **Solution**: Check variable validation rules

### Debug Commands

```bash
# Plan with detailed output
terraform plan -detailed-exitcode

# Validate configuration
terraform validate

# Check state
terraform show
```

## Future Enhancements

### Planned Features

1. **Time-Bound Assignments**: Support for temporary role assignments
2. **Conditional Assignments**: Environment-based permission variations
3. **Role Definition Management**: Custom role definition support
4. **Audit Logging**: Enhanced audit trail capabilities
5. **Multi-Subscription Support**: Cross-subscription RBAC management

### Extension Points

1. **Custom Principals**: Support for additional principal types
2. **Advanced Scopes**: Support for management group and resource-level scopes
3. **Policy Integration**: Integration with Azure Policy for RBAC governance
4. **Automation APIs**: Programmatic RBAC management interfaces

## Conclusion

The RBAC Management System provides a secure, scalable, and maintainable approach to Azure RBAC management. By combining human-readable configuration with dynamic runtime resolution, it addresses the key challenges of enterprise access control while maintaining security best practices and operational efficiency.

The system's modular design ensures flexibility for future enhancements while providing a solid foundation for current RBAC requirements. Comprehensive validation and error handling minimize deployment risks, while the clear separation of concerns makes the system maintainable and auditable.
