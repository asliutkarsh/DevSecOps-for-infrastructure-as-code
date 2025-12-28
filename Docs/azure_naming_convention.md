# Azure Naming Convention & Standards

## 1. Purpose

This document defines the naming standards for all Azure resources within the **AJFC** (Dummy) organization. Adherence to this standard is mandatory for all new deployments to ensure consistency, predictability, and automation capabilities across our **Hub-Spoke** architecture.

---

## 2. Global Rules

All resources must follow the **Enterprise Naming Format**. The format differs slightly between the **Core Hub** (shared/permanent) and **Spokes** (project-specific/ephemeral).

### General Formatting

* **Case:** All names must be **lowercase**.
* **Separator:** Use hyphens (`-`) for all resources **except** Storage Accounts and Container Registries (which do not support them).
* **Length:** Keep project codes short (max 4-6 chars) to satisfy Azure storage account limits (24 chars max).

---

## 3. Naming Formulas

### A. Core Hub (Platform)

The Hub is a singleton, shared foundation. It does **not** carry an environment tag (like dev/prod) in the name because it serves all environments simultaneously.

**Format:**
`[ResourceType]-[Org]-[Scope]-[Location]-[Component]-[Instance]`

| Segment | Value | Description |
| :--- | :--- | :--- |
| **ResourceType** | `rg`, `vnet`, `kv` | Abbreviation of the Azure resource. |
| **Org** | `ajfc` | The organization identifier. |
| **Scope** | `hub` | Hardcoded scope for Core resources. |
| **Location** | `cin`, `eus` | Short code for the region. |
| **Component** | `network`, `data` | The architectural layer. |
| **Instance** | `01` | Two-digit sequence number. |

### B. Spokes (Workloads/Projects)

Spokes are isolated workloads that can have multiple environments (Dev, UAT, Prod).

**Format:**
`[ResourceType]-[Org]-[Project]-[Env]-[Location]-[Component]-[Instance]`

| Segment | Value | Description |
| :--- | :--- | :--- |
| **ResourceType** | `rg`, `aks`, `st` | Abbreviation of the Azure resource. |
| **Org** | `ajfc` | The organization identifier. |
| **Project** | `custbot`, `ragbot` | **Short code** for the project (Max 6 chars). |
| **Env** | `dev`, `uat`, `prod` | The deployment environment. |
| **Location** | `cin`, `eus` | Short code for the region. |
| **Component** | `compute`, `ai` | The architectural layer/function. |
| **Instance** | `01` | Two-digit sequence number. |

---

## 4. Resource Abbreviations

Use these standard abbreviations. Do not invent new ones without approval.

| Resource Type | Abbreviation | Example (Spoke) | Example (Hub) |
| :--- | :--- | :--- | :--- |
| **Resource Group** | `rg` | `rg-ajfc-ragbot-dev-cin-data-01` | `rg-ajfc-hub-cin-data-01` |
| **Virtual Network** | `vnet` | `vnet-ajfc-ragbot-dev-cin-01` | `vnet-ajfc-hub-cin-01` |
| **Subnet** | `snet` | `snet-private-endpoint` | `AzureFirewallSubnet` |
| **NSG** | `nsg` | `nsg-ajfc-ragbot-dev-cin-web-01` | N/A |
| **Storage Account** | `st` | `stajfcragbotdevcindata01` | `stajfchubcindata01` |
| **Key Vault** | `kv` | `kv-ajfc-ragbot-dev-cin-data-01` | `kv-ajfc-hub-cin-data-01` |
| **AKS Cluster** | `aks` | `aks-ajfc-ragbot-dev-cin-01` | N/A |
| **Container Registry** | `acr` | `acrajfcragbotdevcin01` | `acrajfchubcin01` |
| **App Service Plan** | `asp` | `asp-ajfc-ragbot-dev-cin-01` | N/A |
| **App Service** | `app` | `app-ajfc-ragbot-dev-cin-fe-01` | N/A |
| **Log Analytics** | `log` | `log-ajfc-ragbot-dev-cin-01` | `log-ajfc-hub-cin-01` |
| **Managed Identity** | `id` | `id-ajfc-ragbot-dev-cin-app-01` | `id-ajfc-hub-cin-github-01` |

---

## 5. Location Codes

We map full Azure region names to 3-letter standard codes.

| Azure Region | Short Code |
| :--- | :--- |
| **Central India** | `cin` |
| **East US** | `eus` |
| **West Europe** | `weu` |
| **South India** | `sin` |

---

## 6. Real-World Examples

### Scenario 1: Hub Storage Account

Adding a storage account for "Audit Logs" in the Hub (Central India).

* **Result:** `stajfchubcindata02`

### Scenario 2: New Spoke Project

Creating a "Finance Automation Bot" (`finbot`) in Dev, Central India.

* **Resource Group:** `rg-ajfc-finbot-dev-cin-data-01`
* **Key Vault:** `kv-ajfc-finbot-dev-cin-data-01`
* **AKS:** `aks-ajfc-finbot-dev-cin-01`

---

## 7. Tagging Standards

Tags are mandatory. Since the **Hub** name does not contain environment data, tags are the source of truth for billing.

| Tag Name | Value Example | Description |
| :--- | :--- | :--- |
| **Project** | `hub`, `custbot` | Matches "Scope" or "Project" in name. |
| **Environment** | `Production`, `Dev` | Lifecycle stage. **Critical for Hub.** |
| **Owner** | `Platform Team` | Team responsible for the bill. |
| **ManagedBy** | `Terraform` | Deployment tool used. |

### Hub Tagging Example (JSON)

```json
{
  "Project": "Hub",
  "Environment": "Shared-Core",
  "Owner": "Platform Team",
  "ManagedBy": "Terraform"
}
