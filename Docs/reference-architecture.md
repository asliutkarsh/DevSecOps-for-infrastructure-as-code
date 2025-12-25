# Azure Hub–Spoke (Core–Spoke) Terraform Repository

## Enterprise Standard

## 1. Purpose

This repository defines the **standard Azure Core–Spoke architecture** and **Terraform structure** used across the organization.

The objectives are to:

- Ensure consistency across all projects
- Enable centralized control for networking, security, and governance
- Allow independent workload development via spokes
- Separate **infrastructure code** from **deployment configuration**
- Establish Terraform as the **single source of truth**

This standard must be followed by all platform and project teams.

---

## 2. Architectural Overview

We follow a **Core–Spoke model** with clear ownership boundaries.

### Core (Previously Hub)

- Central platform and control plane
- Shared by all workloads
- Deployed once and reused everywhere
- Owned and managed by the **Platform Team**

### Spokes

- One spoke per project or workload
- Fully isolated from other spokes
- Connected to Core using approved patterns
- Owned and managed by **Project / Application Teams**

This model enables centralized governance without slowing down delivery.

---

## 3. Standard Resource Classification

Every **Core** and **Spoke** follows the same classification model:

- **Network**
- **Data**
- **Compute**
- **AI**

Additionally, **Core-only** includes:

- **RBAC / Identity**
- **Governance**

This keeps the structure predictable and scalable.

---

## 4. Core Classification (Centralized)

Core contains **shared and control-plane services only**.

### Network

- Core VNet and subnets
- VNet Peering to Spokes
- Azure Firewall
- Bastion
- Application Gateway & WAF
- ExpressRoute / VPN Gateway / s2S / P2S
- Centralised Private DNS zones
- Front Door, DDoS Protection (if applicable)

### Data

- Central Log Analytics Workspace
- Central Storage (logs, archive, backup)
- Central Key Vault
- Shared Databricks (if required)

### Compute

- API Management (APIM) (if applicable)
- Shared App Service Plans (if applicable)
- Shared integration components (if applicable)

### AI

- Centralized Azure OpenAI (if required)
- Shared AI platforms (if applicable)

### RBAC / Identity

- Centralised Managed Identities
- Microsoft Entra ID groups, users & roles
- RBAC role assignments
- PIM and access governance

### Governance

- Azure Policy (definitions & initiatives)
- Defender for Cloud
- Cost management and budgets

---

## 5. Spoke Classification (Workload-Specific)

Each spoke represents **one project or workload**.

### Network

- Spoke VNet and subnets
- NSGs and UDRs
- Private Endpoints

### Data

- Storage (Blob / ADLS / File Shares)
- SQL / Cosmos DB
- Project-specific Databricks
- Logic Apps
- Workload Key Vault
- Event Hubs / Service Bus
- Event Grid
- Synapse Analytics

### Compute

- VM / VMSS
- AKS
- App Service / Functions
- Azure Container Registry (ACR)
- Container Instances
- Azure Container Apps

### AI

- Azure OpenAI (project-specific)
- Azure Cognitive Services
- Azure Foundry Services
- Azure ML (project-specific)
- Azure AI Search

⚠️ Spokes must **never** define RBAC or Governance resources.

---

## 6. Terraform Repository Structure

### Infrastructure Code (Reusable)

```text
terraform/
├── modules/
│   ├── networking/
│   ├── compute/
│   ├── data/
│   ├── ai/
│   ├── security/
│   └── identity/
│
└── workloads/
    ├── core/
    │   ├── network/
    │   ├── data/
    │   ├── compute/
    │   ├── ai/
    │   ├── rbac/
    │   └── governance/
    │
    └── spokes/
        ├── abc-project/
        │   ├── network/
        │   ├── data/
        │   ├── compute/
        │   └── ai/
        │
        └── xyz-project/
            ├── network/
            ├── data/
            ├── compute/
            └── ai/
```

## 7. Deployment Configuration (Environment-Specific)

Environment-specific values are not stored with the code.
They live in a dedicated Deployment layer.

Deployment Structure

```text
terraform/
└── deployment/
    ├── core/
    │   ├── network/
    │   │   └── network.tfvars
    │   ├── data/
    │   │   └── data.tfvars
    │   ├── compute/
    │   │   └── compute.tfvars
    │   ├── ai/
    │   ├── rbac/
    │   └── governance/
    │
    └── spokes/
        ├── abc-project/
        │   ├── network/
        │   │   └── network.tfvars
        │   ├── data/
        │   ├── compute/
        │   └── ai/
        └── xyz-project/
            ├── network/
            │   └── network.tfvars
            ├── data/
            ├── compute/
            └── ai/
```

## 8. Ownership and Responsibilities

Example: Deploy Core Network

```bash
cd terraform/deployment/core/network
terraform init
terraform apply -var-file=../../../deployment/core/network/network.tfvars
```

Example: Deploy Spoke Network

```bash
cd terraform/deployment/spokes/abc-project/network
terraform init
terraform apply -var-file=../../../deployment/spokes/abc-project/network/network.tfvars
```

## 9. Key Principles (Mandatory)

- Core is owned by the Platform Team
- Spokes are owned by Project Teams
- No direct internet exposure from spokes
- No RBAC or Policy definitions in spokes
- Deployment configuration is separated from code
- Terraform is the single source of truth
- Each folder maintains its own Terraform state
- Use modules for reusable components
- Follow naming conventions and tagging standards
