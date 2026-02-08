resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.nsg_location
  resource_group_name = var.resource_group_name
  tags                = var.nsg_tags
}

resource "azurerm_network_security_rule" "rules" {
  for_each = var.nsg_rules

  name                        = each.value.name
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_range      = each.value.destination_port_range
  description                 = each.value.description

  resource_group_name = var.resource_group_name
}