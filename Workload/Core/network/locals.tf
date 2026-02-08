locals {
  resource_group_name = "rg-${var.tenant_name}-hub-${var.location_code}-network-01"
  vnet_name           = "vnet-${var.tenant_name}-hub-${var.location_code}-01"

  # Generate subnet names based on configuration
  # If use_subnet_name is true and custom_name is not empty, use custom_name
  # Otherwise, use the default format: snet-{environment}-{key} (snet-core-pe-01)
  subnet_names = {
    for key, config in var.subnets_config : key => (
      config.use_subnet_name && config.custom_name != ""
      ? config.custom_name
      : "snet-${var.environment}-${key}"
    )
  }

  # Dynamic NSG names based on subnet - each subnet gets its own NSG
  # Format: nsg-{tenant_name}-{environment}-{location_code}-{subnet_key}-01
  # Example: nsg-core-prod-cin-pe-01
  nsg_names = {
    for key in keys(var.subnet_nsg_rule_map) : key =>
    "nsg-${var.tenant_name}-${var.environment}-${var.location_code}-${key}-01"
  }

  # Generate NSG rules for each subnet from the rule map with priority overrides
  # Format: { subnet_key => { rule_name => rule_config } }
  # Example: { "pe" => { "allow-bastion" => { ... } } }
  subnet_nsg_rules = {
    for subnet_key, rule_configs in var.subnet_nsg_rule_map : subnet_key => {
      for rule_config in rule_configs :
      rule_config.name => merge(
        local.nsg_rules_config[rule_config.name],
        rule_config.priority != null ? { priority = rule_config.priority } : {}
      )
    }
  }

  # Generate NSG rules with default rules concatenated to all subnets - Disabled for now
  # Format: { subnet_key => { rule_name => rule_config } }
  # Example: { "pe" => { "allow-bastion" => { ... }, "allow-default" => { ... } } }
  # subnet_nsg_rules = {
  #   for subnet_key, rule_configs in var.subnet_nsg_rule_map : subnet_key => {
  #     for rule_config in concat(var.default_nsg_rules, rule_configs) :
  #     rule_config.name => merge(
  #       local.nsg_rules_config[rule_config.name],
  #       rule_config.priority != null ? { priority = rule_config.priority } : {}
  #     )
  #   }
  # }

  # Shared Route Tables - Create route tables based on route_tables variable - key = hub
  # Format: rt-{tenant_name}-{environment}-{location_code}-{route_table_key}-01
  # Example: rt-core-prod-cin-hub-01
  route_table_names = {
    for key, config in var.route_tables : key =>
    config.name != "" ? config.name : "rt-${var.tenant_name}-${var.environment}-${var.location_code}-${key}-01"
  }

  # Generate routes for each shared route table
  # Format: { route_table_key => { route_key => route_config } }
  # Example: { "hub" => { "to-internet" => { ... } } }
  subnet_routes = {
    for rt_key, config in var.route_tables : rt_key => {
      for route_key in config.routes : route_key => local.route_definitions_config[route_key]
    }
  }

  # One Route Table per Subnet - Disabled for now
  # Dynamic Route Table names based on subnet (One route table per subnet)
  # Format: rt-{tenant_name}-{environment}-{location_code}-{subnet_key}-01
  # Example: rt-core-prod-cin-pe-01
  # route_table_names = {
  #   for key in keys(var.subnet_route_map) : key =>
  #   "rt-${var.tenant_name}-${var.environment}-${var.location_code}-${key}-01"
  # }

  # Generate routes for each subnet from the route map (One route table per subnet)
  # Format: { subnet_key => { route_key => route_config } }
  # Example: { "pe" => { "to-internet" => { ... } } }
  # subnet_routes = {
  #   for subnet_key, route_keys in var.subnet_route_map : subnet_key => {
  #     for route_key in route_keys : route_key => local.route_definitions_config[route_key]
  #   }
  # }

  # Map NSG IDs to subnets for association
  # Format: { subnet_key => nsg_id }
  # Example: { "pe" => "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/networkSecurityGroups/..." }
  subnet_nsg_ids = {
    for key in keys(local.nsg_names) : key => module.nsg_subnet[key].nsg_id
  }

  # Map Route Table IDs to subnets for association (Shared route tables - key = hub)
  # Format: { subnet_key => route_table_id }
  # Example: { "pe" => "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/routeTables/..." }
  subnet_route_table_ids = {
    for subnet_key, config in var.subnets_config : subnet_key =>
    config.route_table_key != "" && contains(keys(local.route_table_names), config.route_table_key) ? module.rt_subnet[config.route_table_key].route_table_id : ""
  }

  # Alternative: Map Route Table IDs to subnets for association (One route table per subnet) - Disabled for now
  # Format: { subnet_key => route_table_id }
  # Example: { "pe" => "/subscriptions/.../resourceGroups/.../providers/Microsoft.Network/routeTables/..." }
  # subnet_route_table_ids = {
  #   for key in keys(local.route_table_names) : key => module.rt_subnet[key].route_table_id
  # }

  subnet_delegation_null = {
    subnet_delegation_name  = ""
    service_delegation_name = ""
    actions                 = []
  }

  common_tags = merge(var.tags, {
    Project     = "Hub"
    Environment = title(var.environment)
    Owner       = var.app_owner_name
    ManagedBy   = "Terraform"
  })
}
