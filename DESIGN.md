# Design

This document is the authoritative reference for naming, tagging, and Terraform code standards in this repository. [`AGENTS.md`](AGENTS.md) references this document and provides AI-agent-optimized summaries for code generation.

## Naming Conventions

This project follows the Azure Cloud Adoption Framework (CAF) naming pattern:

`<resource-type>-<workload>-[component]-<environment>-<region>-[###]`

Parameters in `[brackets]` are optional:

| Parameter | Required | Description |
|---|---|---|
| `resource-type` | Yes | Azure resource type abbreviation (e.g. `rg`, `st`, `vnet`, `kv`) |
| `workload` | Yes | Workload name — use `local.effective_workload` |
| `component` | **No** | Only include when a workload deploys **multiple resources of the same type with distinct logical roles** (e.g. `logs` vs `data`) |
| `environment` | Yes | Deployment environment (e.g. `dev`, `prod`) — use `var.environment` |
| `region` | Yes | Azure region (e.g. `eastus`) — use `var.region` |
| `instance` | **No** | Zero-padded instance count (e.g. `001`, `002`) — include when multiple identical instances of a resource may exist (e.g. VMs, VNets, NICs) |

**Single resource of a type** (omit both `component` and `instance`):
```
rg-myapp-prod-eastus
kv-myapp-prod-eastus
```

**Multiple resources with distinct logical roles** (use `component`, omit `instance`):
```
st-myapp-logs-prod-eastus
st-myapp-data-prod-eastus
```

**Multiple identical instances** (omit `component`, use `instance`):
```
vm-myapp-prod-eastus-001
vm-myapp-prod-eastus-002
```

**Multiple identical instances with a shared role** (use both `component` and `instance`):
```
vm-myapp-web-prod-eastus-001
vm-myapp-web-prod-eastus-002
```

### Resource-Specific Naming Constraints

Some Azure resource types impose character restrictions or length limits that conflict with the standard hyphenated pattern. Adapt the pattern as described when deploying these resource types:

| Resource Type | Prefix | Max Length | Constraints | Adaptation |
|---|---|---|---|---|
| Resource Group | `rg` | 90 | Alphanumeric, hyphens, underscores, periods | Standard pattern applies |
| Virtual Network | `vnet` | 64 | Alphanumeric, hyphens, underscores, periods | Standard pattern applies |
| Key Vault | `kv` | 24 | Alphanumeric and hyphens | Standard pattern applies; watch total length |
| Storage Account | `st` | 24 | Lowercase alphanumeric only — **no hyphens** | Strip hyphens and truncate |
| Container Registry | `cr` | 50 | Alphanumeric only — **no hyphens** | Strip hyphens |
| Virtual Machine (Windows) | `vm` | 15 | Alphanumeric and hyphens | Shorten workload/region segments |
| Virtual Machine (Linux) | `vm` | 64 | Alphanumeric and hyphens | Standard pattern applies |

For resources that cannot use hyphens, strip them and truncate in the name local:

```hcl
# Storage account — hyphens not allowed, 3–24 chars
locals {
  storage_account_name = substr(
    replace("st${local.effective_workload}${var.environment}${var.region}", "-", ""),
    0, 24
  )
}
```

### Globally Unique Names

Some Azure resources require globally unique names (Storage Accounts, Key Vaults, Azure Container Registry, etc.). For these, append a short deterministic 4-character hex suffix derived from the resource group ID after it is created:

```hcl
locals {
  resource_suffix      = substr(md5(azurerm_resource_group.main.id), 0, 4)
  storage_account_name = substr(
    replace("st${local.effective_workload}${var.environment}${var.region}${local.resource_suffix}", "-", ""),
    0, 24
  )
}
```

This ensures names are deterministic across `plan`/`apply` cycles once the resource group exists.

**Reference:**
* [Microsoft Cloud Adoption Framework | Resource Naming](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
* [Azure resource abbreviations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)

---

## Resource Tagging

This project follows the CAF tagging taxonomy. Tags are split into required tags (applied to all resources via `local.default_tags`) and recommended extended tags (injected per-workload via `var.additional_tags`).

### Required Tags

These tags are applied to every resource by default through `locals.tf`:

| Tag | Source | Description |
|---|---|---|
| `Project` | `var.project` | Project or application name |
| `Workload` | `local.effective_workload` | Specific workload within the project |
| `Owner` | `var.owner` | Team or individual responsible for the workload |
| `Environment` | `var.environment` | Deployment environment |
| `Region` | `var.region` | Azure region |
| `ManagedBy` | `"Terraform"` (hardcoded) | IaC tool managing the resource |

### Recommended Accounting Tags

Use these via `additional_tags` for cost allocation, chargeback, and financial governance:

| Tag | Example Values | Purpose |
|---|---|---|
| `CostCenter` | `55332`, `fin-ops-001` | Cost allocation and chargeback |
| `Department` | `engineering`, `finance`, `platform` | Organizational unit owner |
| `Budget` | `$200,000`, `$50,000` | Budget cap for the workload |
| `BusinessUnit` | `platform`, `data`, `security` | Business unit responsible for the resource |

### Recommended Classification Tags

Use these via `additional_tags` for governance, security policy enforcement, and SLA management:

| Tag | Allowed Values | Purpose |
|---|---|---|
| `Criticality` | `Mission-Critical` \| `High` \| `Medium` \| `Low` | SLA and incident priority tier |
| `DataClassification` | `Confidential` \| `General` \| `Public` | Data sensitivity for governance policies |
| `SLA` | `99.99%` \| `99.9%` \| `99%` | Target availability SLA |
| `DR` | `Mission-Critical` \| `Business-Critical` \| `BC/DR-Enabled` \| `Dev-Test` | Disaster recovery tier |

### Tag Value Standards

Use only the canonical values defined above — do not free-form these tags. Inconsistent casing or alternate spellings (e.g. `mission-critical` vs `Mission-Critical`) break Azure Policy assignments and cost filter queries.

**Reference:**
* [Microsoft Cloud Adoption Framework | Resource Tagging](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)

---

## Terraform Code Standards

These standards define how Terraform configuration must be written to maintain CAF alignment. They apply to all `.tf` files in this repository.

### Support Resources

Terraform resources that exist solely to generate computed values consumed by `locals.tf` (e.g. `random_pet`, `random_id`) are **support resources**. They belong in `locals.tf`, placed immediately above the `locals` block they feed, so the computation and its dependency are collocated.

Infrastructure resources — any `azurerm_*`, `azuread_*`, or similar provider resources that deploy actual cloud infrastructure — must remain in `main.tf`.

**Rule of thumb:** if removing a resource would require changing only `locals.tf` and nothing in `main.tf`, it is a support resource.

```hcl
# locals.tf — support resource lives here, above the local that consumes it
resource "random_pet" "workload" {
  length    = 1
  separator = "-"
}

locals {
  effective_workload = var.workload == null ? random_pet.workload.id : var.workload
}
```

### Variable Design

| Rule | When to Apply |
|---|---|
| Add `sensitive = true` | Variable may contain PII, email addresses, passwords, or API keys |
| Add `validation` block | Variable has a constrained value set or format |
| Omit `default` | Value must be explicitly set per deployment with no sensible generic fallback |
| Use `default = null` | Variable is optional; guard with `var.x == null` checks in locals |

Variables that may contain personally identifiable information must be marked `sensitive = true` to prevent values from appearing in `terraform plan` or `apply` output:

```hcl
variable "owner" {
  type        = string
  sensitive   = true
  description = "Email or name of the team or individual responsible for this workload."
}
```

Use `validation` blocks to enforce allowed values and catch configuration errors at plan time:

```hcl
variable "criticality" {
  type        = string
  description = "Workload criticality tier for SLA and incident prioritization."
  default     = "Medium"

  validation {
    condition     = contains(["Mission-Critical", "High", "Medium", "Low"], var.criticality)
    error_message = "criticality must be one of: Mission-Critical, High, Medium, Low."
  }
}
```

### `count` vs `for_each` for Multi-Instance Resources

| Pattern | Use When | CAF Name Segment Used |
|---|---|---|
| `count` | Deploying N homogeneous, identical instances | Instance number: `-001`, `-002` |
| `for_each` | Deploying named or role-distinct instances | Component segment: `-web-`, `-db-` |

```hcl
# count — homogeneous instances, use zero-padded CAF instance suffix
resource "azurerm_linux_virtual_machine" "web" {
  count = var.instance_count
  name  = "vm-${local.effective_workload}-${var.environment}-${var.region}-${format("%03d", count.index + 1)}"
}

# for_each — named instances, use component segment instead of instance number
resource "azurerm_subnet" "this" {
  for_each = var.subnets  # map(object) keyed by component name (e.g. "web", "db")
  name     = "snet-${local.effective_workload}-${each.key}-${var.environment}-${var.region}"
}
```

### `lifecycle` Rules and Criticality Mapping

CAF criticality classification maps to Terraform lifecycle protections. Apply `lifecycle` blocks based on the resource's `Criticality` tag value:

| Criticality | Required Lifecycle Rule | Typical Resource Types |
|---|---|---|
| `Mission-Critical` / `High` | `prevent_destroy = true` | Databases, storage accounts, Key Vaults, production VNets |
| Any stateful resource | `ignore_changes = [tags["<tag>"]]` | When specific tags are also managed by Azure Policy |
| Zero-downtime replacements | `create_before_destroy = true` | Public IPs, certificates, App Service plans |

```hcl
resource "azurerm_mssql_database" "main" {
  name      = "sql-${local.effective_workload}-${var.environment}-${var.region}"
  server_id = azurerm_mssql_server.main.id
  # ...
  lifecycle {
    prevent_destroy = true
  }
}
```

### Resource Locks

CAF governance requires `azurerm_management_lock` on production resources to prevent accidental deletion. Apply based on environment:

| Environment | Lock Requirement | Lock Level |
|---|---|---|
| `prod` | **Required** | `CanNotDelete` |
| `staging` | Recommended | `CanNotDelete` |
| `dev` / `test` | Not required | — |

```hcl
resource "azurerm_management_lock" "rg" {
  count      = contains(["prod", "staging"], var.environment) ? 1 : 0
  name       = "lock-${local.effective_workload}-${var.environment}"
  scope      = azurerm_resource_group.main.id
  lock_level = "CanNotDelete"
  notes      = "Managed by Terraform. Required for ${var.environment} environment per CAF governance."
}
```

### Computed Name Locals

If a resource name string is referenced more than once (e.g., in `name` and as a `Name` tag value), extract it to `locals.tf` to prevent drift. Name locals follow the convention `<resource_type>_name`:

```hcl
# locals.tf
locals {
  resource_group_name = "rg-${local.effective_workload}-${var.environment}-${var.region}"
}

# main.tf
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.region
  tags     = merge(local.default_tags, { Name = local.resource_group_name })
}
```

---

## Remote State Key Convention

When using the Azure Blob Storage backend (recommended for all non-development deployments), the state file `key` must follow this pattern to support multiple environments per workload within a shared container:

```
<workload>/<environment>.terraform.tfstate
```

Example `backend "azurerm"` configuration:

```hcl
backend "azurerm" {
  resource_group_name  = "<tfstate-resource-group>"
  storage_account_name = "<tfstate-storage-account>"
  container_name       = "tfstate"
  key                  = "<workload>/<environment>.terraform.tfstate"
}
```

This namespaces state files by workload and environment, preventing collisions and enabling per-environment `terraform state` operations within a single storage container.

**Reference:**
* [HashiCorp Terraform | Azure Backend](https://developer.hashicorp.com/terraform/language/backend/azurerm)
