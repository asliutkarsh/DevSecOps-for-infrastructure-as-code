output "virtual_network_name" {
  value       = azurerm_virtual_network.virtual_network.name
  description = "The name of the Azure Virtual Network."
}

output "virtual_network_id" {
  value       = azurerm_virtual_network.virtual_network.id
  description = "The ID of the Azure Virtual Network."
}