# Project Configuration
org            = "ajfc"
project        = "cusbot"
environment    = "dev"
location_code  = "cin"
app_owner_name = "AI Bot Team"

# Azure Configuration
resource_group_location = "centralindia"

# Managed Identities
managed_identities = {
  app = {
    federated_credentials = {}
  }
  aks = {
    federated_credentials = {}
  }
  aks-agentpool = {
    federated_credentials = {}
  }
}
