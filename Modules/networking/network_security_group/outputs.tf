output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.nsg.id
}

output "nsg_name" {
  description = "Name of the network security group"
  value       = azurerm_network_security_group.nsg.name
}

output "nsg_rules" {
  description = "Map of NSG rule IDs"
  value = {
    for rule_name, rule in azurerm_network_security_rule.rules :
    rule_name => rule.id
  }
}