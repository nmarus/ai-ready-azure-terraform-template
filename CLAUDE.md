# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an Azure Infrastructure as Code (IaC) Terraform template that provisions an Azure Resource Group with standardized naming and tagging conventions based on the Azure Cloud Adoption Framework (CAF).

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

## Architecture

The template follows a flat single-module structure (no nested modules):

- **`variables.tf`** — Six input variables: `project`, `workload`, `owner`, `environment`, `region`, `additional_tags`
- **`locals.tf`** — Computes `effective_workload` (falls back to `random_pet` if `workload` is null) and `default_tags` (merged with `additional_tags`)
- **`main.tf`** — `random_pet` resource for workload fallback and `azurerm_resource_group` resource
- **`outputs.tf`** — Exposes all variable values plus the deployed `resource_group_name`
- **`providers.tf`** — Requires Terraform ≥1.14, azurerm ~>4.0, random ~>3.8; local state backend with a commented `backend "azurerm"` remote state example; sets `prevent_deletion_if_contains_resources = true` (non-empty resource groups will block `terraform destroy`)

## Naming & Tagging Conventions

**Resource naming pattern**: `<resource-type>-<workload>-<environment>-<region>`

**Default tags applied to all resources**:
```
Project, Workload, Owner, Environment, Region, ManagedBy
```

Additional tags can be injected via the `additional_tags` variable (e.g., cost center, ticket number) without modifying `locals.tf`.

## Pre-commit Hook Pipeline

Hooks run in order on every commit:
1. `terraform_fmt` — formats all `.tf` files
2. `terraform_docs` — regenerates the `<!-- BEGIN_TF_DOCS -->` section in README.md
3. `terraform_validate` — validates configuration
4. `terraform_tflint` — lints with `.tflint.hcl` rules
5. `terraform_checkov` — security scanning

## TFLint Rules

Key enforced rules (see `.tflint.hcl`):
- All variables and outputs must have `description` and `type`
- Snake_case naming convention required
- `#` comment syntax required (not `//`)
- No unused variables, locals, or providers
- `required_version` and `required_providers` blocks mandatory

## Variable Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` to configure (`.tfvars` files are gitignored). All variables have defaults. The `environment` variable is validated against `dev`, `test`, `staging`, `prod`. The `workload` variable is validated for lowercase alphanumeric characters and hyphens (2-24 chars).

## CI/CD

`.github/workflows/terraform.yml` runs on every PR to `main` and on every push to `main` (when `.tf` or `.tfvars` files change). Steps: `terraform fmt -check`, `terraform init -backend=false`, `terraform validate`, `tflint`, `checkov`. No Azure credentials are required — init runs with `-backend=false` so no backend is configured during CI.

## Documentation

- `DEPENDENCIES.md` — tool installation instructions for Windows/macOS/Linux
- `DEPLOYMENT.md` — step-by-step deployment guide
- `DESIGN.md` — naming conventions and tagging standards

## Editor Configuration

`.editorconfig` enforces 2-space indentation, LF line endings, and UTF-8 for all `.tf`, `.yml`, `.json`, and `.md` files. All major editors and AI coding agents respect this automatically.
