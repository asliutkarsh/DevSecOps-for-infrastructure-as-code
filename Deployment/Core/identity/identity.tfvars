tenant_name             = "ajfc"
app_owner_name          = "Platform Team"
environment             = "hub"
resource_group_location = "centralindia"
location_code           = "cin"

# Managed Identities Configuration
identities = [
  {
    identity_suffix = "github-terraform"
    federated_credentials = [
      {
        name     = "main"
        audience = ["api://AzureADTokenExchange"]
        issuer   = "https://token.actions.githubusercontent.com"
        subject  = "repo:asliutkarsh/DevSecOps-for-infrastructure-as-code:ref:refs/heads/main"
      },
      {
        name     = "core-hub"
        audience = ["api://AzureADTokenExchange"]
        issuer   = "https://token.actions.githubusercontent.com"
        subject  = "repo:asliutkarsh/DevSecOps-for-infrastructure-as-code:environment:core-hub"
      }
    ]
  }
]

rbac_assignments = {
  # "github_terraform_subscription_access" = {
  #   principal_type                    = "managed_identity"
  #   principal_name                    = "id-ajfc-hub-cin-github-terraform-01"
  #   role_name                         = "Owner"
  #   scope_type                        = "subscription"
  #   scope_name                        = "subscription"
  #   managed_identities_resource_group = "rg-ajfc-hub-cin-core-01"
  #   description                       = "GitHub Actions Terraform identity with subscription owner access for infrastructure deployment"
  # }
}
