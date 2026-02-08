# Networking Infrastructure Practice Guide

## Overview

This document provides comprehensive guidance on the Terraform networking implementation in the `Workload/Core/network` directory. It covers the architecture, implementation patterns, extensibility features, and best practices for maintaining and extending the codebase.

## Architecture Overview

The networking implementation follows a modular, scalable architecture that supports multiple deployment scenarios and configuration patterns. It uses Terraform locals extensively for data transformation and supports both simple and complex networking requirements.

### Key Principles

1. **Separation of Concerns**: Variables, logic, and configuration are separated into distinct files
2. **Extensibility**: Multiple scenarios supported with commented alternatives
3. **Scalability**: Supports both simple and complex networking setups
4. **Maintainability**: Clear naming conventions and comprehensive documentation

## File Structure and Responsibilities

### Core Files

#### `variables.tf`

Defines all input variables with proper typing and validation.

**Key Variables:**

- `subnet_nsg_rule_map`: NSG rule configurations with priority overrides
- `route_tables`: Shared route table definitions
- `subnets_config`: Subnet configurations with associations
- `default_nsg_rules`: Global rules applied to all subnets (commented scenario)

#### `locals.tf`

Contains all data transformation logic using Terraform expressions.

**Key Responsibilities:**

- Generate resource names dynamically
- Transform configuration data into module inputs
- Handle different deployment scenarios
- Merge configurations with defaults

#### `main.tf`

Orchestrates resource creation using reusable modules.

**Module Structure:**

- `resource_group`: Infrastructure foundation
- `virtual_network`: Network backbone
- `nsg_subnet`: Security group per subnet
- `rt_subnet`: Route table management
- `subnet`: Final subnet creation with associations

#### `nsg_rules.tf`

Centralized NSG rule definitions with consistent configuration.

#### `routes.tf`

Centralized route definitions for different traffic patterns.

## Implementation Scenarios

### Scenario 1: Dynamic Priorities (Active)

**Problem**: Same NSG rule needed with different priorities across subnets.

**Solution**: `subnet_nsg_rule_map` accepts objects with optional priority overrides.

```hcl
subnet_nsg_rule_map = {
  web = [
    { name = "allow_https_inbound" }  # Uses default priority (200)
  ]
  api = [
    { name = "allow_https_inbound", priority = 150 }  # Override priority
  ]
}
```

**Logic Flow:**

1. `locals.tf` merges base rule config with priority override
2. `merge()` function combines configurations
3. Result passed to NSG module

### Scenario 2: Shared Route Tables (Active)

**Problem**: Multiple subnets need identical routing.

**Solution**: `route_tables` variable defines shared route tables.

```hcl
route_tables = {
  hub = {
    routes = ["allow_internet", "to_onpremises"]
  }
}

subnets_config = {
  web = {
    route_table_key = "hub"  # References shared route table
  }
  api = {
    route_table_key = "hub"  # Same route table
  }
}
```

### Scenario 3: Global NSG Rules (Commented)

**Problem**: Compliance rules needed on all subnets.

**Solution**: `default_nsg_rules` concatenated with subnet-specific rules.

```hcl
default_nsg_rules = [
  { name = "enable_logging" },  # Applied to ALL subnets
  { name = "compliance_check" }
]

# In locals.tf (commented):
subnet_nsg_rules = {
  for subnet_key, rule_configs in var.subnet_nsg_rule_map : subnet_key => {
    for rule_config in concat(var.default_nsg_rules, rule_configs) :
    # ... merge logic
  }
}
```

### Scenario 4: Per-Subnet Route Tables (Commented)

**Problem**: Each subnet needs unique routing (legacy approach).

**Solution**: `subnet_route_map` creates individual route tables.

```hcl
subnet_route_map = {
  web = ["internet_via_firewall"]
  db  = ["all_to_firewall"]
}

# Creates: rt-tenant-env-region-web-01, rt-tenant-env-region-db-01
```

## Data Flow and Logic

### NSG Rule Processing

```bash
subnet_nsg_rule_map (variables.tf)
    ↓
locals.tf: subnet_nsg_rules
    ↓ merge() with local.nsg_rules_config
    ↓
module.nsg_subnet.nsg_rules
    ↓
Azure NSG Rules
```

### Route Table Processing

```bash
route_tables + subnets_config (variables.tf)
    ↓
locals.tf: route_table_names + subnet_routes
    ↓
module.rt_subnet
    ↓
locals.tf: subnet_route_table_ids
    ↓
module.subnet.rt_id
    ↓
Azure Route Table Associations
```

## Variable Structures

### subnets_config

```hcl
variable "subnets_config" {
  type = map(object({
    address_prefix  = string
    use_subnet_name = bool
    custom_name     = optional(string, "")
    route_table_key = optional(string, "")
    delegation = optional(object({
      name                    = string
      service_delegation_name = string
      actions                 = optional(list(string), [])
    }), null)
    private_endpoint_network_policies             = optional(string, "Disabled")
    service_endpoints                             = optional(list(string), null)
    private_link_service_network_policies_enabled = optional(bool, null)
  }))
}
```

### subnet_nsg_rule_map

```hcl
variable "subnet_nsg_rule_map" {
  type = map(list(object({
    name     = string
    priority = optional(number)
  })))
}
```

## Extending the Implementation

### Adding New NSG Rules

1. **Add to nsg_rules.tf:**

   ```hcl
    allow_custom_port = {
      name                       = "AllowCustomPort"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "8080"
      description                = "Allow custom port"
    }
    ```

2. **Use in configuration:**

   ```hcl
    subnet_nsg_rule_map = {
      app = [
        { name = "allow_custom_port" }
      ]
    }
    ```

### Adding New Route Types

1. **Add to routes.tf:**

   ```hcl
      to_custom_network = {
        name                = "ToCustomNetwork"
        address_prefix      = "192.168.0.0/16"
        next_hop_type       = "VirtualAppliance"
        next_hop_ip_address = "10.0.0.4"
      }
      ```

2. **Reference in route_tables:**

   ```hcl
    route_tables = {
      custom = {
        routes = ["to_custom_network", "allow_internet"]
      }
    }
    ```

### Adding New Scenarios

1. **Comment existing logic in locals.tf**
2. **Add new variable if needed**
3. **Implement new transformation logic**
4. **Update main.tf if module calls change**
5. **Document the new scenario**

## Naming Conventions

### Resources

- Resource Groups: `rg-{tenant}-hub-{location}-network-01`
- VNets: `vnet-{tenant}-hub-{location}-01`
- Subnets: `snet-{env}-{key}` or custom name
- NSGs: `nsg-${var.tenant_name}-${var.environment}-${var.location_code}-${key}-01`
- Route Tables: `rt-{tenant}-{env}-{location}-{key}-01`

### Variables

- Snake_case: `subnet_nsg_rule_map`, `route_tables`
- Descriptive: `default_nsg_rules`, `subnet_route_associations`

### Locals

- Clear prefixes: `subnet_nsg_rules`, `route_table_names`
- Comprehensive comments explaining transformations

## Best Practices

### Configuration Management

1. **Use Descriptive Keys**: `web`, `api`, `db` instead of `subnet1`, `subnet2`
2. **Group Related Rules**: Keep related NSG rules together
3. **Document Overrides**: Comment priority overrides explaining why
4. **Version Control**: Track changes to rule configurations

### Performance Considerations

1. **Minimize Route Tables**: Use shared route tables when possible
2. **Optimize NSG Rules**: Combine rules where possible
3. **Use Appropriate Scopes**: Apply rules at subnet level, not individual VMs

### Security Best Practices

1. **Principle of Least Privilege**: Deny by default, allow explicitly
2. **Regular Audits**: Review and update rules periodically
3. **Compliance Rules**: Use default_nsg_rules for mandatory security controls
4. **Network Segmentation**: Use different NSGs for different security zones

## Troubleshooting

### Common Issues

1. **Priority Conflicts**: Ensure NSG rule priorities don't conflict
2. **Route Table Associations**: Verify route_table_key references exist
3. **Variable Types**: Check terraform plan for type validation errors

### Debugging Steps

1. **Validate Configuration:**

   ```bash
    terraform validate
    ```

2. **Check Variable Values:**

   ```bash
    terraform plan -var-file=network.tfvars
    ```

3. **Inspect Locals:**

   ```hcl
    output "debug_nsg_rules" {
      value = local.subnet_nsg_rules
    }
    ```

### Scalability Considerations

1. **Module Reuse**: Extract common patterns into reusable modules
2. **Configuration Generation**: Use external data sources for large configurations
3. **State Management**: Optimize for large numbers of subnets

## Conclusion

This networking implementation provides a flexible, scalable foundation for Azure network infrastructure. The modular design supports multiple deployment scenarios while maintaining clean, maintainable code. Regular review and updates based on security requirements and Azure best practices are recommended.

For questions or contributions, refer to the inline comments and maintain the established patterns when extending the codebase.
