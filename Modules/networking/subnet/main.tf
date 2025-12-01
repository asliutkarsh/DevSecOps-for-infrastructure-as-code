resource "azurerm_subnet" "subnets" {
  name                                          = var.subnet_name
  resource_group_name                           = var.subnet_resource_group_name
  address_prefixes                              = var.subnet_address_prefixes
  virtual_network_name                          = var.virtual_network_name
  private_endpoint_network_policies             = var.private_endpoint_network_policies
  private_link_service_network_policies_enabled = var.private_link_service_network_policies_enabled
  service_endpoints                             = var.service_endpoints
  dynamic "delegation" {
    for_each = var.subnet_delegations == {} ? [] : ["delegation"]
    content {
      name = var.subnet_delegations.subnet_delegation_name
      service_delegation {
        name    = var.subnet_delegations.service_delegation_name
        actions = var.subnet_delegations.actions
      }
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  count                     = var.subnet_nsg_association == true ? 1 : 0
  subnet_id                 = azurerm_subnet.subnets.id
  network_security_group_id = var.nsg_id
  depends_on                = [azurerm_subnet.subnets]
  lifecycle {
    ignore_changes = all
  }
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  count          = var.subnet_rt_association == true ? 1 : 0
  subnet_id      = azurerm_subnet.subnets.id
  route_table_id = var.rt_id
  depends_on     = [azurerm_subnet.subnets]
  lifecycle {
    ignore_changes = all
  }
}