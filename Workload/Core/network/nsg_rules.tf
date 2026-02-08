locals {
  nsg_rules_config = {
    deny_all_inbound = {
      name                       = "DenyAllInbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description                = "Deny all inbound traffic"
    },

    deny_all_outbound = {
      name                       = "DenyAllOutbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description                = "Deny all outbound traffic"
    },

    allow_https_inbound = {
      name                       = "AllowHTTPSInbound"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      description                = "Allow HTTPS inbound"
    },

    allow_http_inbound = {
      name                       = "AllowHTTPInbound"
      priority                   = 201
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "80"
      description                = "Allow HTTP inbound"
    },

    allow_ssh_inbound = {
      name                       = "AllowSSHInbound"
      priority                   = 202
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "22"
      description                = "Allow SSH inbound"
    },

    allow_rdp_inbound = {
      name                       = "AllowRDPInbound"
      priority                   = 203
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "3389"
      description                = "Allow RDP inbound"
    },

    allow_app_gateway_health = {
      name                       = "AllowAppGatewayHealth"
      priority                   = 204
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "GatewayManager"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "65200-65535"
      description                = "Allow Azure Application Gateway health probes"
    },

    allow_azure_load_balancer = {
      name                       = "AllowAzureLoadBalancer"
      priority                   = 205
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "AzureLoadBalancer"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      description                = "Allow Azure Load Balancer health probes"
    },

    allow_sql_outbound = {
      name                       = "AllowSQLOutbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "Sql"
      destination_port_range     = "1433"
      description                = "Allow outbound to SQL Database"
    },

    allow_https_outbound = {
      name                       = "AllowHTTPSOutbound"
      priority                   = 101
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      description                = "Allow outbound HTTPS"
    }
  }
}