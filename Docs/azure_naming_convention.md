# Azure Naming Convention & Standards

## 1. Purpose

This document defines the naming standards for all Azure resources within the **AJFC** (Dummy) organization. Adherence to this standard is mandatory for all new deployments to ensure consistency, predictability, and automation capabilities across our **Hub-Spoke** architecture.

---

## 2. Global Rules

All resources must follow the **Enterprise Naming Format**. The format differs slightly between the **Core Hub** (which is shared/permanent) and **Spokes** (which are project-specific/ephemeral).

### General Formatting

- **Case:** All names must be **lowercase**.
- **Separator:** Use hyphens (`-`) for all resources except Storage Accounts and Container Registries (which do not support them).
- **Length:** Keep project codes short (max 4-6 chars) to satisfy Azure storage account limits (24 chars max).

---

## 3. Naming Formulas

### A. Core Hub (Platform)

The Hub is a singleton, shared foundation. It does **not** carry an environment tag (like dev/prod) in its name because it serves all environments simultaneously.

**Format:**
`[ResourceType]-[Org]-[Scope]-[Location]-[Component]-[Instance]`

| Segment | Value | Description |
| :--- | :--- | :--- |
| **ResourceType** | `rg`, `vnet`, `kv` | Abbreviation of the Azure resource. |
| **Org** | `ajfc` | The organization identifier. |
| **Scope** | `hub` | Hardcoded scope for Core resources. |
| **Location** | `cin`, `eus` | Short code for the region (see Reference). |
| **Component** | `network`, `data` | The architectural layer (Network, Data, Identity). |
| **Instance** | `01` | Two-digit sequence number. |

### B. Spokes (Workloads/Projects)

Spokes are isolated workloads that can have multiple environments (Dev, UAT, Prod).

**Format:**
`[ResourceType]-[Org]-[Project]-[Env]-[Component]-[Instance]`

| Segment | Value | Description |
| :--- | :--- | :--- |
| **ResourceType** | `rg`, `aks`, `st` | Abbreviation of the Azure resource. |
| **Org** | `ajfc` | The organization identifier. |
| **Project** | `custbot`, `ragbot` | **Short code** for the project (Max 6 chars). |
| **Env** | `dev`, `uat`, `prod` | The deployment environment. |
| **Component** | `compute`, `ai` | The architectural layer. |
| **Instance** | `01` | Two-digit sequence number. |

---

## 4. Resource Abbreviations (Reference)

Use these standard abbreviations. Do not invent new ones without approval.

| Resource Type | Abbreviation | Example (Spoke) | Example (Hub) |
| :--- | :--- | :--- | :--- |
| **Resource Group** | `rg` | `rg-ajfc-ragbot-dev-data-01` | `rg-ajfc-hub-cin-data-01` |
| **Virtual Network** | `vnet` | `vnet-ajfc-ragbot-dev-01` | `vnet-ajfc-hub-cin-01` |
| **Network Security Group** | `nsg` | `nsg-ajfc-ragbot-dev-web-01` | N/A |
| **Storage Account** | `st` | `stajfcragbotdevdata01` | `stajfchubcindata01` |
| **Key Vault** | `kv` | `kv-ajfc-ragbot-dev-data-01` | `kv-ajfc-hub-cin-data-01` |
| **AKS Cluster** | `aks` | `aks-ajfc-ragbot-dev-01` | N/A |
| **Container Registry** | `acr` | `acrajfcragbotdev01` | `acrajfchub01` |
| **App Service Plan** | `asp` | `asp-ajfc-ragbot-dev-01` | N/A |
| **App Service** | `app` | `app-ajfc-ragbot-dev-fe-01` | N/A |
| **Log Analytics** | `log` | `log-ajfc-ragbot-dev-01` | `log-ajfc-hub-cin-01` |
| **User Managed Identity** | `id` | `id-ajfc-ragbot-dev-app-01` | `id-ajfc-hub-cin-github-01` |

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

### Scenario 1: Adding a new Storage Account to the Hub

You need to add a storage account for "Audit Logs" in the Hub (Central India).

1. **Type:** `st`
2. **Org:** `ajfc`
3. **Scope:** `hub`
4. **Loc:** `cin`
5. **Component:** `data`
6. **Instance:** `02` (since `01` is taken)

**Result:** `stajfchubcindata02`

### Scenario 2: Creating a New Project (Spoke)

You are starting a new project called "Finance Automation Bot".

1. **Define Project Code:** `finbot` (Short, < 6 chars).
2. **Environment:** `dev`
3. **Location:** `cin`

**Resources to create:**

- **Resource Group:** `rg-ajfc-finbot-dev-data-01`
- **Key Vault:** `kv-ajfc-finbot-dev-data-01`
- **AKS:** `aks-ajfc-finbot-dev-01`

---

## 7. Tagging Standards

Tags are mandatory for all resources. Because the Core Hub does not have "dev" or "prod" in its name, the **Environment tag** is the critical source of truth for billing and management.

### Mandatory Tags

| Tag Name | Value Example | Description |
| :--- | :--- | :--- |
| **Project** | `hub`, `custbot`, `ragbot` | Must match the "Scope" or "Project" used in the name. |
| **Environment** | `Production`, `Development`, `UAT` | The lifecycle stage. **Critically important for Hub.** |
| **Owner** | `Team` | The team or individual responsible for the bill. |
| **ManagedBy** | `Terraform` | Indicates this resource should not be changed manually. |

### Special Rule for Hub (Core)

Since the Hub is a shared resource, it is always considered "Production" grade infrastructure, even if it supports Dev workloads.

**Hub Tagging Example:**

```json
{
  "Project": "Hub",
  "Environment": "Shared-Core",
  "Owner": "Platform Team",
  "ManagedBy": "Terraform"
}
```
