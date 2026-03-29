# Azure Terraform Template

This project demonstrates a production ready template for utilizing Terraform to manage Azure infrastructure.

# Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.0 |
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
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment environment. Defaults to dev if not defined. | `string` | `"dev"` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Name of owner for resource naming. Defaults to 'Azure Cloud Team' if not defined. | `string` | `"Azure Cloud Team"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name for resource tagging. Defaults to 'Azure Deployment' if not defined. | `string` | `"Azure Deployment"` | no |
| <a name="input_region"></a> [region](#input\_region) | Azure region to deploy resources. Defaults to eastus if not defined. | `string` | `"eastus"` | no |
| <a name="input_workload"></a> [workload](#input\_workload) | Name of workload for resource naming. Defaults to random if not defined. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_client_config"></a> [azurerm\_client\_config](#output\_azurerm\_client\_config) | The current client configuration |
| <a name="output_environment"></a> [environment](#output\_environment) | The deployment environment being used |
| <a name="output_owner"></a> [owner](#output\_owner) | The owner name being used |
| <a name="output_project"></a> [project](#output\_project) | The project name being used |
| <a name="output_region"></a> [region](#output\_region) | The Azure region being used |
| <a name="output_workload"></a> [workload](#output\_workload) | The workload name being used |
<!-- END_TF_DOCS -->
