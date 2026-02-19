# Project Configuration
org            = "ajfc"
project        = "cusbot"
environment    = "dev"
location_code  = "cin"
app_owner_name = "AI Bot Team"

# Azure Configuration
resource_group_location = "centralindia"

# Virtual Network
vnet_config = {
  address_space = ["10.2.0.0/16"]
  dns_servers   = []
}

# Subnet Configuration
# NSG on: compute, pe | Route Table on: compute, aks
subnets_config = {
  compute = {
    address_prefix  = "10.2.1.0/24"
    use_subnet_name = false
    route_table_key = "compute"
  }
  aks = {
    address_prefix  = "10.2.2.0/24"
    use_subnet_name = false
    route_table_key = "aks"
  }
  pe = {
    address_prefix                    = "10.2.3.0/24"
    use_subnet_name                   = false
    private_endpoint_network_policies = "Enabled"
  }
}

# NSG Rules — applied to compute and pe subnets
subnet_nsg_rule_map = {
  compute = [
    # { name = "allow_https_inbound" },
    # { name = "allow_ssh_inbound" },
    # { name = "allow_azure_load_balancer" },
    # { name = "allow_https_outbound" },
    # { name = "allow_vnet_inbound" },
    # { name = "allow_vnet_outbound" }
  ]
  pe = [
    # { name = "allow_vnet_inbound" },
    # { name = "allow_vnet_outbound" },
    # { name = "allow_https_outbound" },
    # { name = "deny_all_inbound", priority = 4096 }
  ]
}

# Route Tables — compute and aks subnets
route_tables = {
  compute = {
    # routes = ["internet_via_firewall"]
    routes = []
  }
  aks = {
    # routes = ["internet_via_firewall"]
    routes = []
  }
}
