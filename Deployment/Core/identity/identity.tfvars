tenant_name="ajfc"
app_owner_name="Platform Team"
environment="hub"
resource_group_location="centralindia"
location_code="cin"
identities = [
  {
    identity_suffix = "github-terraform"
    role_definition_map = {
      "Subscription" = "Owner"
    }
    federated_credentials = [
      {
        name     = "main"
        audience = ["api://AzureADTokenExchange"]
        issuer   = "https://token.actions.githubusercontent.com"
        subject  = "repo:asliutkarsh/DevSecOps-for-infrastructure-as-code:ref:refs/heads/main"
      },
      {
        name     = "env-prod"
        audience = ["api://AzureADTokenExchange"]
        issuer   = "https://token.actions.githubusercontent.com"
        subject  = "repo:asliutkarsh/DevSecOps-for-infrastructure-as-code:environment:production"
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