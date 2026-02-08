output "route_table_id" {
  description = "ID of the route table"
  value       = azurerm_route_table.rt.id
}

output "route_table_name" {
  description = "Name of the route table"
  value       = azurerm_route_table.rt.name
}