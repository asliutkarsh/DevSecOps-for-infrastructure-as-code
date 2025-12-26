# DevSecOps for Infrastructure as Code (Terraform + Azure)

This repository demonstrates an **enterprise‑grade Infrastructure as Code (IaC)** setup using **Terraform**, **Azure**, and **GitHub Actions** with **OIDC authentication**.  
It is structured to mirror how large organizations run IaC in production: clear separation of concerns, reusable CI/CD, and secure-by-default practices.

---

## 🧠 What This Repository Showcases

- Enterprise Terraform repository structure (Core + Spokes)
- Separation of:
  - **Workloads** (`Workload/`)
  - **Environment configuration** (`Deployment/`)
  - **Pipelines** (`.github/workflows/`)
- Reusable GitHub Actions workflows (`plan` / `apply`)
- Azure authentication using **OIDC** (no long‑lived secrets in CI)
- Remote Terraform state in Azure Storage
- Environment‑aware deployments (dev / test / prod)
- Production‑ready CI/CD strategy for Terraform on Azure

---

## 🏗️ High‑Level Architecture

The solution follows a **Core–Spoke** model:

- **Core**  
  Shared, centrally managed services such as:
  - Hub virtual network
  - Shared identity and security components
  - Common data or platform services

- **Spokes**  
  Individual project or application environments, e.g.:
  - `Workload/Spokes/abc-project/`
  - Each spoke owns its networking, compute, and app‑specific resources
  - Onboarded through a standard CI/CD pattern

- **Configuration vs Code**  
  - Terraform **code** lives under `Workload/`
  - Environment‑specific **configuration** (`*.tfvars`) lives under `Deployment/`
  - Pipelines stitch these together via inputs.

For full details of the directory layout, components, and flows, see:

- **Reference Architecture**:  
  [Docs/reference-architecture.md](./Docs/reference-architecture.md)

---

## 📁 Repository Structure (Overview)

A simplified view of the structure:

```text
.
├── .github/
│   └── workflows/                # Reusable and caller GitHub Actions workflows
├── Deployment/                   # Environment configuration (.tfvars)
│   ├── Core/                     # Core/Shared/Hub environment
│   └── Spokes/                   # Per‑project / per‑spoke configs
├── Modules/                      # Reusable Terraform modules
│   ├── networking/
│   ├── resource_group/
│   ├── role_assignment/
│   └── storage/
├── Workload/                     # Terraform code (what gets deployed)
│   ├── Core/                     # Shared/core components
│   └── Spokes/                   # Individual spokes (e.g. abc-project)
└── Docs/                         # Documentation
    ├── reference-architecture.md
    ├── coding-style.md
    ├── ci-cd-strategy.md
    └── ci-cd-reference.md
```

---

## 💻 Coding Style & Terraform Conventions

The repo follows consistent Terraform coding standards so teams can collaborate safely:

- Clear module boundaries (small, reusable modules in `Modules/`)
- Consistent naming conventions for:
  - Resources
  - Variables
  - State keys
- Opinionated layout for Core vs Spokes
- Emphasis on readability and maintainability

For detailed rules, examples, and conventions, see:

- **Coding Standards**:  
  [Docs/coding-style.md](./Docs/coding-style.md)

---

## 🔄 CI/CD Strategy (Overview)

CI/CD is implemented with **GitHub Actions** and organized around:

- **Reusable workflows**:
  - `terraform-plan.yml` – validates, scans, and creates a `tfplan` artifact
  - `terraform-apply.yml` – applies an approved plan using the stored artifact
- **Caller workflows**:
  - Per‑component / per‑spoke workflows (e.g. `abc-project-plan-apply.yml`)
  - Only pass in:
    - `working_directory`
    - `tfvars_file`
    - `state_key`
    - `component_name`
- **Plan‑Apply pattern** with:
  - Manual approvals via GitHub Environments
  - Clear separation between what is planned vs what is applied
- **Security**:
  - OIDC‑based auth to Azure (no static secrets)
  - Centralized backend state in Azure Storage

For the overall CI/CD approach and design decisions, see:

- **CI/CD Strategy** (why and how):  
  [Docs/ci-cd-strategy.md](./Docs/ci-cd-strategy.md)

For hands‑on, workflow‑level details, inputs, and examples (including `abc-project` onboarding), see:

- **CI/CD Reference** (how to wire pipelines):  
  [Docs/ci-cd-reference.md](./Docs/ci-cd-reference.md)

---

## 🚀 Getting Started (High Level)

1. **Review the architecture**  
   Understand the Core–Spoke model and directory structure:  
   [Docs/reference-architecture.md](./Docs/reference-architecture.md)

2. **Follow coding standards**  
   Ensure new modules and workloads follow the shared style:  
   [Docs/coding-style.md](./Docs/coding-style.md)

3. **Configure CI/CD**  
   - Make sure required GitHub secrets and Azure state resources exist
   - Use the examples in:  
     [Docs/ci-cd-reference.md](./Docs/ci-cd-reference.md)

4. **Onboard a new Spoke**  
   - Create `Workload/Spokes/<project>/...`
   - Add corresponding `Deployment/Spokes/<project>/.../*.tfvars`
   - Add a caller workflow (e.g. `abc-project-plan-apply.yml`) using the provided template

---

## 🔐 Security & State Management (Brief)

- **OIDC Authentication**  
  GitHub Actions uses OpenID Connect to obtain tokens from Azure, avoiding long‑lived credentials in CI.

- **Remote State**  
  Terraform state is stored in an Azure Storage Account + container dedicated to Terraform states, with:
  - Proper access control
  - State locking
  - Per‑component / per‑spoke keys (`state_key` inputs)

Details (including required secrets and troubleshooting) are in:

- [Docs/ci-cd-reference.md](./Docs/ci-cd-reference.md)

---

## 📚 Where to Go Next

- **Architecture deep dive**:  
  [Docs/reference-architecture.md](./Docs/reference-architecture.md)

- **Coding standards & patterns**:  
  [Docs/coding-style.md](./Docs/coding-style.md)

- **High‑level CI/CD strategy**:  
  [Docs/ci-cd-strategy.md](./Docs/ci-cd-strategy.md)

- **CI/CD implementation reference (workflows, inputs, examples)**:  
  [Docs/ci-cd-reference.md](./Docs/ci-cd-reference.md)

- **Azure Naming Convention**:  
  [Docs/azure_naming_convention.md](./Docs/azure_naming_convention.md)

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---
