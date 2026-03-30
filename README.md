# AI-Ready Azure Terraform Template

[![Terraform](https://github.com/nmarus/ai-ready-azure-terraform-template/actions/workflows/terraform.yml/badge.svg)](https://github.com/nmarus/ai-ready-azure-terraform-template/actions/workflows/terraform.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A starter template purpose-built for AI-assisted Azure Terraform development. It gives AI coding agents (Claude Code, GitHub Copilot, Cursor, Codex, and others) the structure, context, and guardrails they need to generate correct, compliant Azure infrastructure code — without constant hand-holding.

The template follows the [Azure Cloud Adoption Framework (CAF)](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/) for naming and tagging, enforces standards automatically via pre-commit hooks and CI, and ships with agent-specific context files for every major AI coding tool so each agent understands the project conventions from the first prompt.

Use this as a foundation: clone it, point your agent at it, and start building.

## Prerequisites

See [DEPENDENCIES.md](DEPENDENCIES.md) for tool installation instructions (Terraform, Azure CLI, pre-commit, tflint, checkov).

## Using AI Coding Agents

This repo is designed from the ground up so AI coding agents have the context they need to produce correct, compliant Terraform without extra hand-holding.

**Primary context file**: [`AGENTS.md`](AGENTS.md) — single source of truth containing architecture, file layout, naming workflow, and enforced constraints. All agent-specific files point here.

| Agent | Discovery | File |
|-------|-----------|------|
| Claude Code | Automatic | [`.claude/CLAUDE.md`](.claude/CLAUDE.md) → `AGENTS.md` |
| OpenAI Codex | Automatic | [`AGENTS.md`](AGENTS.md) |
| Opencode | Automatic | [`AGENTS.md`](AGENTS.md) |
| GitHub Copilot | Automatic | [`.github/copilot-instructions.md`](.github/copilot-instructions.md) → `AGENTS.md` |
| Cursor | Automatic | [`.cursor/rules/terraform.mdc`](.cursor/rules/terraform.mdc) → `AGENTS.md` |

**Supporting context**:
- [`DESIGN.md`](DESIGN.md) — CAF naming conventions and tagging standards
- [`terraform.tfvars.example`](terraform.tfvars.example) — available inputs and their defaults

**Example starter prompts**:
```
Add an Azure Key Vault to this template.
```
```
Add two Azure Storage Accounts — one for app logs, one for data.
```
```
Configure remote state using Azure Blob Storage. See the commented backend block in providers.tf.
```

**What's enforced automatically**: pre-commit hooks and CI validate formatting, naming, tagging, and security on every commit and PR. The agent does not need to be reminded of every rule — running `pre-commit run --all-files` will surface any violations.

## Quick Start

1. Copy the example vars file: `cp terraform.tfvars.example terraform.tfvars`
2. Edit `terraform.tfvars` with your values (all fields are optional — defaults work out of the box)
3. Authenticate with Azure: `az login`
4. _(If you have multiple subscriptions)_ Set the target subscription: `az account set --subscription "<subscription-id>"`
5. `terraform init`
6. `terraform plan -var-file="terraform.tfvars"`
7. `terraform apply -var-file="terraform.tfvars"`

See [DEPLOYMENT.md](DEPLOYMENT.md) for the full step-by-step deployment guide.

## Work in Progress

This template is actively evolving. The core structure is stable and usable today, but there is plenty of room to grow — more resource examples, additional agent integrations, expanded guardrails, and real-world patterns contributed by people using it in the field.

**Feedback and contributions are very welcome:**

- Found a bug or gap? [Open an issue](../../issues)
- Have an improvement idea? [Start a discussion or open a PR](../../issues)
- Using this template in your own project? Please share — open an issue and tell us how you're using it, what's working, and what isn't. That context directly shapes what gets built next.

## Related Documentation

| Document | Purpose |
|---|---|
| [DEPLOYMENT.md](DEPLOYMENT.md) | Full step-by-step deployment guide |
| [DESIGN.md](DESIGN.md) | CAF naming conventions and tagging standards |
| [DEPENDENCIES.md](DEPENDENCIES.md) | Tool installation instructions |

## Terraform Reference

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
