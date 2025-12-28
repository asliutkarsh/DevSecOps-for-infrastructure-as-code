variable "location" {
  type        = string
  description = "The Azure region where all resources will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the existing Azure resource group in which resources will be created."
}

variable "user_assigned_identity_name" {
  type        = string
  description = "The name of the User Assigned Managed Identity to be created."
}

variable "federated_credentials" {
  type = map(object({
    name     = string
    audience = list(string)
    issuer   = string
    subject  = string
  }))

  description = <<EOF
    A map of federated identity credential definitions.
    Each map entry creates one azurerm_federated_identity_credential resource.
    Fields:
    - name:     The name of the federated identity credential.
    - audience: The audience value (usually a resource application ID, e.g. 'api://AzureADTokenExchange').
    - issuer:   The OIDC provider URL (e.g. GitHub Actions 'https://token.actions.githubusercontent.com').
    - subject:  The subject identifier used by the identity provider (e.g. repo/workflow reference).
    EOF
}
