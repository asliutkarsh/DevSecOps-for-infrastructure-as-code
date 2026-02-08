locals {
  route_definitions_config = {
    all_to_firewall = {
      name                = "AllToFirewall"
      address_prefix      = "0.0.0.0/0"
      next_hop_type       = "VirtualAppliance"
      next_hop_ip_address = "10.0.0.4"
    },

    internet_via_firewall = {
      name                = "InternetViaFirewall"
      address_prefix      = "0.0.0.0/0"
      next_hop_type       = "VirtualAppliance"
      next_hop_ip_address = "10.0.0.4"
    },

    to_onpremises = {
      name                = "ToOnPremises"
      address_prefix      = "10.0.0.0/8"
      next_hop_type       = "VirtualAppliance"
      next_hop_ip_address = "10.0.0.4"
    },

    to_hub_network = {
      name                = "ToHubNetwork"
      address_prefix      = "172.16.0.0/12"
      next_hop_type       = "VirtualAppliance"
      next_hop_ip_address = "10.0.0.4"
    },

    allow_internet = {
      name                = "AllowInternet"
      address_prefix      = "0.0.0.0/0"
      next_hop_type       = "Internet"
      next_hop_ip_address = ""
    }
  }
}