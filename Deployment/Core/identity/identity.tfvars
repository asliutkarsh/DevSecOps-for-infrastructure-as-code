tenant_name="ajfc"
app_name="test"
app_owner_name="utkarsh"
environment="hub"
resource_group_location="centralindia"
identities = [
  {
    identity_suffix = "github-terraform"
    role_definition_name = "Owner"
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