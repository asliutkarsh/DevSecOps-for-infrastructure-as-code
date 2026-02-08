output "resource_group_id" {
  description = "ID of the network resource group"
  value       = module.resource_group.resource_group_id
}

output "resource_group_name" {
  description = "Name of the network resource group"
  value       = module.resource_group.resource_group_name
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = module.virtual_network.virtual_network_id
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = module.virtual_network.virtual_network_name
}

output "subnet_ids" {
  description = "Map of subnet IDs"
  value = {
    for key in keys(var.subnets_config) : key => module.subnet[key].subnet_id
  }
}

output "subnet_names" {
  description = "Map of subnet names"
  value       = local.subnet_names
}

output "nsg_ids" {
  description = "Map of NSG IDs by subnet key"
  value = {
    for key in keys(local.nsg_names) : key => module.nsg_subnet[key].nsg_id
  }
}

output "nsg_names" {
  description = "Map of NSG names by subnet key"
  value       = local.nsg_names
}

output "route_table_ids" {
  description = "Map of route table IDs by subnet key"
  value = {
    for key in keys(local.route_table_names) : key => module.rt_subnet[key].route_table_id
  }
}

output "route_table_names" {
  description = "Map of route table names by subnet key"
  value       = local.route_table_names
}