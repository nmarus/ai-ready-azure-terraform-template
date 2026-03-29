# Azure Terraform Template

A production-ready Terraform template for deploying Azure infrastructure following the [Azure Cloud Adoption Framework (CAF)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/) naming and tagging conventions.

## What This Deploys

- **Resource Group** — named using the CAF pattern `rg-<workload>-<environment>-<region>`, with standardized tags applied
- A random workload name is generated automatically if `workload` is not supplied

## Quick Start

1. Copy the example vars file: `cp terraform.tfvars.example terraform.tfvars`
2. Edit `terraform.tfvars` with your values (all fields are optional — defaults work out of the box)
3. Authenticate with Azure: `az login && az account set --subscription "<subscription-id>"`
4. `terraform init`
5. `terraform plan -var-file="terraform.tfvars"`
6. `terraform apply -var-file="terraform.tfvars"`

See [DEPLOYMENT.md](DEPLOYMENT.md) for the full step-by-step deployment guide.

## Extending This Template

To add new Azure resources, follow the workflow in [CLAUDE.md](CLAUDE.md#how-to-add-a-resource). Naming, tagging, and file placement rules are enforced by pre-commit hooks and CI — run `pre-commit run --all-files` before committing.

## Using AI Coding Agents

This repo is structured to give AI coding agents the context they need to produce correct, compliant Terraform without extra hand-holding.

**Primary context file**: [`CLAUDE.md`](CLAUDE.md) — contains architecture overview, file layout, naming workflow, and enforced constraints. Claude Code loads it automatically. For other agents (Cursor, Copilot, etc.), start your session by telling the agent to read `CLAUDE.md` first.

**Supporting context**:
- [`DESIGN.md`](DESIGN.md) — CAF naming conventions and tagging standards
- [`terraform.tfvars.example`](terraform.tfvars.example) — available inputs and their defaults

**Example starter prompts**:
```
Add an Azure Key Vault to this template. Follow the patterns in CLAUDE.md.
```
```
Add two Azure Storage Accounts — one for app logs, one for data. Follow the patterns in CLAUDE.md.
```
```
Configure remote state using Azure Blob Storage. See the commented backend block in providers.tf.
```

**What's enforced automatically**: pre-commit hooks and CI validate formatting, naming, tagging, and security on every commit and PR. The agent does not need to be reminded of every rule — running `pre-commit run --all-files` will surface any violations.

## Prerequisites

See [DEPENDENCIES.md](DEPENDENCIES.md) for tool installation instructions (Terraform, Azure CLI, pre-commit, tflint, checkov).

## Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.8 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.66.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.8.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [random_pet.workload](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to merge with the default tags. Use for workload-specific metadata such as cost center, ticket number, or compliance labels. | `map(string)` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. Must be one of: dev, test, staging, prod. Defaults to 'dev' if not defined. | `string` | `"dev"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Name or email of the team or individual responsible for this workload. Defaults to 'Azure Cloud Team' if not defined. | `string` | `"Azure Cloud Team"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for resource tagging. Defaults to 'Azure Deployment' if not defined. | `string` | `"Azure Deployment"` | no |
| <a name="input_region"></a> [region](#input\_region) | Azure region identifier for resource deployment (e.g. 'eastus', 'westeurope'). Defaults to 'eastus' if not defined. | `string` | `"eastus"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Workload name used in resource naming. Must be lowercase alphanumeric and hyphens, 2-24 characters. Defaults to a random name if not defined. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_environment"></a> [environment](#output\_environment) | The deployment environment being used |
| <a name="output_owner"></a> [owner](#output\_owner) | The owner name being used |
| <a name="output_project"></a> [project](#output\_project) | The project name being used |
| <a name="output_region"></a> [region](#output\_region) | The Azure region being used |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the deployed resource group |
| <a name="output_workload"></a> [workload](#output\_workload) | The effective workload name being used (user-supplied or randomly generated) |
<!-- END_TF_DOCS -->
