resource "azurerm_route_table" "rt" {
  name                = var.route_table_name
  location            = var.route_table_location
  resource_group_name = var.resource_group_name
  tags                = var.route_table_tags

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_type == "VirtualAppliance" ? route.value.next_hop_ip_address : null
    }
  }
}
