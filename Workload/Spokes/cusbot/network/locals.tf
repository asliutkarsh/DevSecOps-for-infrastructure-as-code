locals {
  resource_group_name = "rg-${var.org}-${var.project}-${var.environment}-${var.location_code}-network-01"
  vnet_name           = "vnet-${var.org}-${var.project}-${var.environment}-${var.location_code}-01"

  # Generate subnet names based on configuration
  subnet_names = {
    for key, config in var.subnets_config : key => (
      config.use_subnet_name && config.custom_name != ""
      ? config.custom_name
      : "snet-${var.project}-${var.environment}-${key}"
    )
  }

  # Dynamic NSG names — one NSG per subnet that has rules defined
  # Format: nsg-ajfc-custbot-dev-cin-{subnet_key}-01
  nsg_names = {
    for key in keys(var.subnet_nsg_rule_map) : key =>
    "nsg-${var.org}-${var.project}-${var.environment}-${var.location_code}-${key}-01"
  }

  # Generate NSG rules for each subnet from the rule map with priority overrides
  subnet_nsg_rules = {
    for subnet_key, rule_configs in var.subnet_nsg_rule_map : subnet_key => {
      for rule_config in rule_configs :
      rule_config.name => merge(
        local.nsg_rules_config[rule_config.name],
        rule_config.priority != null ? { priority = rule_config.priority } : {}
      )
    }
  }

  # Route table names — one per route table key 
  # Format: rt-ajfc-custbot-dev-cin-{route_table_key}-01
  route_table_names = {
    for key, config in var.route_tables : key =>
    config.name != "" ? config.name : "rt-${var.org}-${var.project}-${var.environment}-${var.location_code}-${key}-01"
  }

  # Generate routes for each route table
  subnet_routes = {
    for rt_key, config in var.route_tables : rt_key => {
      for route_key in config.routes : route_key => local.route_definitions_config[route_key]
    }
  }

  # Map NSG IDs to subnets for association
  subnet_nsg_ids = {
    for key in keys(local.nsg_names) : key => module.nsg_subnet[key].nsg_id
  }

  # Map Route Table IDs to subnets for association (shared route tables)
  subnet_route_table_ids = {
    for subnet_key, config in var.subnets_config : subnet_key =>
    config.route_table_key != "" && contains(keys(local.route_table_names), config.route_table_key) ? module.rt_subnet[config.route_table_key].route_table_id : ""
  }

  common_tags = merge(var.tags, {
    Project     = var.project
    Environment = title(var.environment)
    Owner       = var.app_owner_name
    ManagedBy   = "Terraform"
  })
}
