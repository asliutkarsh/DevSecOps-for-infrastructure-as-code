locals {
  # Spoke naming: rg-ajfc-custbot-dev-cin-identity-01
  resource_group_name = "rg-${var.org}-${var.project}-${var.environment}-${var.location_code}-identity-01"

  # Managed identity names — one per identity defined in var.managed_identities
  # Format: id-ajfc-custbot-dev-cin-{identity_key}-01
  identity_names = {
    for key, config in var.managed_identities : key =>
    config.custom_name != "" ? config.custom_name : "id-${var.org}-${var.project}-${var.environment}-${var.location_code}-${key}-01"
  }

  common_tags = merge(var.tags, {
    Project     = var.project
    Environment = title(var.environment)
    Owner       = var.app_owner_name
    ManagedBy   = "Terraform"
  })
}
