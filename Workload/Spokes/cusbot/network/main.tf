# Resource Group
module "resource_group" {
  source                  = "../../../../Modules/resource_group"
  resource_group_name     = local.resource_group_name
  resource_group_location = var.resource_group_location
  tags                    = local.common_tags
}

# Virtual Network
module "virtual_network" {
  source                        = "../../../../Modules/networking/virtual_network"
  virtual_network_name          = local.vnet_name
  virtual_network_location      = var.resource_group_location
  resource_group_name           = local.resource_group_name
  virtual_network_address_space = var.vnet_config.address_space
  virtual_network_tags          = local.common_tags
  dns_server                    = var.vnet_config.dns_servers

  depends_on = [module.resource_group]
}

# Create NSG for each subnet that has NSG rules defined (compute, pe)
module "nsg_subnet" {
  for_each = local.nsg_names

  source              = "../../../../Modules/networking/network_security_group"
  nsg_name            = each.value
  nsg_location        = var.resource_group_location
  resource_group_name = local.resource_group_name
  nsg_tags            = local.common_tags
  nsg_rules           = lookup(local.subnet_nsg_rules, each.key, {})

  depends_on = [module.resource_group]
}

# Create Route Table for each route table key (compute, aks)
module "rt_subnet" {
  for_each = local.route_table_names

  source               = "../../../../Modules/networking/route_table"
  route_table_name     = each.value
  route_table_location = var.resource_group_location
  resource_group_name  = local.resource_group_name
  route_table_tags     = local.common_tags

  routes = lookup(local.subnet_routes, each.key, {})

  depends_on = [module.resource_group]
}

# Create all subnets with proper NSG and Route Table associations
module "subnet" {
  for_each = var.subnets_config

  source                     = "../../../../Modules/networking/subnet"
  subnet_name                = local.subnet_names[each.key]
  subnet_resource_group_name = local.resource_group_name
  subnet_address_prefixes    = [each.value.address_prefix]
  virtual_network_name       = local.vnet_name
  location                   = var.resource_group_location

  nsg_id                 = lookup(local.subnet_nsg_ids, each.key, "")
  subnet_nsg_association = contains(keys(local.subnet_nsg_ids), each.key)

  rt_id                 = lookup(local.subnet_route_table_ids, each.key, "")
  subnet_rt_association = each.value.route_table_key != ""

  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  service_endpoints = each.value.service_endpoints

  subnet_delegations = each.value.delegation != null ? {
    subnet_delegation_name  = each.value.delegation.name
    service_delegation_name = each.value.delegation.service_delegation_name
    actions                 = each.value.delegation.actions != null ? [for action in each.value.delegation.actions : action] : []
  } : null

  depends_on = [
    module.virtual_network,
    module.nsg_subnet,
    module.rt_subnet
  ]
}
