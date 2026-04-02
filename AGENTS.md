# AGENTS.md

Project context for AI coding agents. This file is the single source of truth — all agent-specific files (`.claude/CLAUDE.md`, `.github/copilot-instructions.md`, `.cursor/rules/terraform.mdc`) point here.

## Project Overview

This is an Azure Infrastructure as Code (IaC) Terraform project that provisions infrastructure in Azure. It includes structures to facilitate best practices, consistent standards, and operational maturity that follows guidelines found in the Azure Cloud Adoption Framework (CAF).

## Architecture

The project is initialized as a flat single-module structure. As the project grows, resources may be split into additional `.tf` files or extracted into child modules — see [File and Module Organization](#file-and-module-organization) for when and how to do this.

- **`variables.tf`** — Six input variables: `project`, `workload`, `owner`, `environment`, `region`, `additional_tags`
- **`locals.tf`** — Computes `effective_workload` (falls back to `random_pet` if `workload` is null) and `default_tags` (merged with `additional_tags`)
- **`main.tf`** — `azurerm_resource_group` resource (and any future **core** infrastructure resources)
- **`outputs.tf`** — Exposes all variable values plus the deployed `resource_group_name`
- **`providers.tf`** — Requires Terraform ≥1.14, azurerm ~>4.0, random ~>3.8; local state backend with a commented `backend "azurerm"` remote state example; sets `prevent_deletion_if_contains_resources = true` (non-empty resource groups will block `terraform destroy`)

## Naming & Tagging Conventions

> See [DESIGN.md](DESIGN.md) for the full naming and tagging standards: pattern reference, resource-specific character constraints, global uniqueness handling, required vs. recommended tags, and canonical tag value lists.

**Resource naming pattern**: `<resource-type>-<workload>-[component]-<environment>-<region>-[###]`

Compose names from locals and variables — never hardcode:
```hcl
# Single resource of a type
name = "<type>-${local.effective_workload}-${var.environment}-${var.region}"

# Multiple resources with distinct logical roles — add component segment
name = "st-${local.effective_workload}-logs-${var.environment}-${var.region}"

# Multiple identical instances — append zero-padded instance number
name = "vm-${local.effective_workload}-${var.environment}-${var.region}-${format("%03d", count.index + 1)}"

# Both component and instance number
name = "vm-${local.effective_workload}-web-${var.environment}-${var.region}-${format("%03d", count.index + 1)}"
```

Use `tags = local.default_tags` on all taggable resources. For resource-specific additional tags:
```hcl
tags = merge(local.default_tags, { Component = "web" })
```

Inject workload-specific extended tags (e.g. `CostCenter`, `Criticality`, `DataClassification`) via `var.additional_tags` — do not modify `locals.tf`.

## How to Add a Resource

1. **Add the resource to `main.tf`** — start here by default; move to a dedicated `.tf` file or child module only when the criteria in [File and Module Organization](#file-and-module-organization) are met
2. **Name it using the CAF pattern** — compose from `local.effective_workload`, `var.environment`, `var.region`; add a `<component>` segment for distinct logical roles; append a zero-padded instance number (`format("%03d", count.index + 1)`) when deploying multiple identical instances; see [DESIGN.md](DESIGN.md) for resource-specific character constraints and global uniqueness handling
3. **Apply tags** — use `tags = local.default_tags` or `tags = merge(local.default_tags, { ... })`
4. **Extract to locals when warranted** — add a `locals` entry in `locals.tf` if the expression is complex to compute or appears in multiple resource blocks; for simple names used only once, inline the expression directly; never create a local that just duplicates a resource attribute Terraform already tracks (e.g. prefer `azurerm_storage_account.main.name` over a redundant local)
5. **Expose outputs** — add relevant outputs (name, id, etc.) to `outputs.tf` with a `description`
6. **Validate** — run `pre-commit run --all-files` to format, validate, lint, and regenerate docs

## Constraints and Guardrails

These rules are enforced by tflint and pre-commit. Violating them causes hook or CI failures:

- **Infrastructure resources start in `main.tf`** — all Azure provider resource blocks begin in `main.tf`; split into additional `.tf` files or child modules only when the criteria in [File and Module Organization](#file-and-module-organization) are met
- **Support resources in `locals.tf`** — non-infrastructure resources that exist solely to compute values consumed by locals (e.g. `random_pet`, `random_id`) are defined in `locals.tf`, immediately above the `locals` block they support
- **Variables require `description` and `type`** — add a `validation` block whenever the input has constraints (allowed values, format, length)
- **Outputs require `description`**
- **Use `#` comments only** — `//` comments are rejected by the `terraform_comment_syntax` tflint rule
- **Never hardcode resource names** — always compose from `local.effective_workload`, `var.environment`, `var.region`, and (when applicable) `count.index` for instance numbers
- **All taggable resources must include tags** — use `tags = local.default_tags` or a `merge()` thereof; never omit tags
- **Run `pre-commit run --all-files` before committing** — formats code, regenerates README docs, validates, lints, and scans for security issues

## File and Module Organization

**Default:** Begin with all infrastructure resources in `main.tf`. Do not pre-emptively split files or create modules — start flat and refactor when a clear threshold is met.

### When to split into additional `.tf` files

Refactor `main.tf` into purpose-grouped files when one or more of these apply:

- `main.tf` exceeds ~150 lines and contains resources from clearly separate concerns
- Multiple distinct services are defined (e.g. networking + compute + storage + monitoring together)
- Readability would be significantly improved by grouping related resources
- Resource separation would improve version control — smaller, focused files produce cleaner commit history, simpler diffs, easier PR reviews, and fewer merge conflicts when multiple contributors are active

Common groupings and the resources they contain:

| File | Typical contents |
|---|---|
| `networking.tf` | VNets, subnets, NSGs, route tables, private endpoints |
| `dns.tf` | Private DNS zones and virtual network links |
| `security.tf` | Key Vault, managed identities, role assignments |
| `monitoring.tf` | Log Analytics workspaces, diagnostic settings, alerts, action groups |
| `logging.tf` | Storage accounts and Event Hubs used for log archival |
| `compute.tf` | Virtual machines, scale sets, App Service plans |
| `storage.tf` | Storage accounts used for application data |

All split files share the same `variables.tf`, `locals.tf`, `outputs.tf`, and `providers.tf`. Support resources (`random_pet`, `random_id`) remain in `locals.tf`.

### When to extract into a child module

Create a module under `modules/<name>/` when:

- A group of resources is reused across multiple environments or workloads with varying parameters
- A self-contained component (e.g. a Log Analytics workspace + diagnostic settings bundle) is deployed more than once
- Encapsulation would meaningfully reduce duplication (DRY principle)

Do not create a module for a group of resources deployed only once — a grouped `.tf` file is simpler and sufficient.

## Common Commands

```bash
# Authenticate with Azure
az login
az account set --subscription "<subscription-id>"

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Preview changes
terraform plan -var-file="terraform.tfvars"

# Apply changes
terraform apply -var-file="terraform.tfvars"

# Destroy infrastructure
terraform destroy -var-file="terraform.tfvars"

# Run pre-commit hooks manually
pre-commit run --all-files

# Generate documentation
terraform-docs markdown table . --output-file README.md

# Run linter
tflint --config=.tflint.hcl

# Run security scan
checkov -d .
```

> See [DEPLOYMENT.md](DEPLOYMENT.md) for the full step-by-step deployment guide, including troubleshooting. See [DEPENDENCIES.md](DEPENDENCIES.md) for tool installation instructions.

## TFLint Rules

Key enforced rules (see `.tflint.hcl`):
- All variables and outputs must have `description` and `type`
- Snake_case naming convention required
- `#` comment syntax required (not `//`)
- No unused variables, locals, or providers
- `required_version` and `required_providers` blocks mandatory

## Variable Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` to configure (`.tfvars` files are gitignored). All variables have defaults. The `environment` variable is validated against `dev`, `test`, `staging`, `prod`. The `workload` variable is validated for lowercase alphanumeric characters and hyphens (2-24 chars).

## Pre-commit Hook Pipeline

Hooks run in order on every commit:
1. `terraform_fmt` — formats all `.tf` files
2. `terraform_docs` — regenerates the `<!-- BEGIN_TF_DOCS -->` section in README.md
3. `terraform_validate` — validates configuration
4. `terraform_tflint` — lints with `.tflint.hcl` rules
5. `terraform_checkov` — security scanning

> See [DEPLOYMENT.md](DEPLOYMENT.md) for operational setup instructions (installing hooks, first-time run).

## CI/CD

`.github/workflows/terraform.yml` runs on every PR to `main` and on every push to `main` (when `.tf` or `.tfvars` files change). Steps: `terraform fmt -check`, `terraform init -backend=false`, `terraform validate`, `tflint`, `checkov`. No Azure credentials are required — init runs with `-backend=false` so no backend is configured during CI.

> See [DEPLOYMENT.md](DEPLOYMENT.md) for CI/CD integration details and pipeline configuration files.

## Documentation

- `DEPENDENCIES.md` — tool installation instructions for Windows/macOS/Linux
- `DEPLOYMENT.md` — step-by-step deployment guide
- `DESIGN.md` — authoritative design standards: naming conventions, tagging taxonomy, Terraform code standards (variable design, `count` vs `for_each`, `lifecycle` rules, resource locks, locals for deduplication), and remote state key convention
