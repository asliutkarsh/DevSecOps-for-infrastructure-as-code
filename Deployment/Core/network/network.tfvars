tenant_name             = "ajfc"
app_owner_name          = "Platform Team"
environment             = "hub"
resource_group_location = "centralindia"
location_code           = "cin"

vnet_config = {
  address_space = ["10.0.0.0/16"]
  dns_servers   = []
}

route_tables = {
  hub = {
    routes = ["allow_internet"]
  },
}

subnets_config = {
  azurefirewall = {
    address_prefix  = "10.0.0.0/24"
    use_subnet_name = true
    custom_name     = "AzureFirewallSubnet"
  },

  azurebastion = {
    address_prefix  = "10.0.2.0/24"
    use_subnet_name = true
    custom_name     = "AzureBastionSubnet"
  },

  appgateway = {
    address_prefix  = "10.0.3.0/24"
    use_subnet_name = true
    custom_name     = "ApplicationGatewaySubnet"
    route_table_key = "hub"
    delegation = {
      name                    = "AppGatewaySubnet"
      service_delegation_name = "Microsoft.Network/applicationGateways"
      actions                 = []
    }
  },

  pe-01 = {
    address_prefix                    = "10.0.1.0/24"
    use_subnet_name                   = false
    private_endpoint_network_policies = "Enabled"
    route_table_key                   = "hub"
  },

  test-01 = {
    address_prefix                    = "10.0.4.0/24"
    use_subnet_name                   = false
    private_endpoint_network_policies = "Enabled"
    route_table_key                   = "hub"
  }
}

# Map each subnet to its NSG rules with optional priority overrides
subnet_nsg_rule_map = {
  pe = [
    { name = "deny_all_inbound" } # Uses default priority (100)
  ],
  test = [
    { name = "deny_all_inbound", priority = 200 }, # Override priority
    { name = "deny_all_outbound", priority = 300 } # Override priority
  ],
  # appgateway = [
  #   { name = "allow_https_inbound" } # Uses default priority (200)
  # ]
}


# This is alternative to route table key where you pass a route table per subnet and routes for them
# One route table per subnet
# subnet_route_map = {
#   pe         = ["all_to_firewall"]
#   appgateway = ["internet_via_firewall"]
#   test       = ["all_to_firewall"]
# }

# subnet_route_associations = {
#   pe         = "firewall-shared"
#   appgateway = "internet-via-firewall"
#   test       = "firewall-shared"
# }
