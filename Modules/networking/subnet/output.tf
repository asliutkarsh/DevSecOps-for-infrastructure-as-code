output "subnet_name" {
  value       = azurerm_subnet.subnets.name
  description = "The name of the Azure Subnet."
}

output "subnet_id" {
  value       = azurerm_subnet.subnets.id
  description = "The ID of the Azure Subnet."
}
