# Design

This document defines the design standards that this project follows.

## Naming Conventions

This project utilizes naming conventions defined in the Azure Cloud Adoption Framework.

`<resource type>-<workload>-<component>-<environment>-<region>`

**Note:** The parameters 'component' and 'region' are optional. Component will be used in more complex workloads that would benefit from a hierarchy at a component level. Region should only used resources that are assigned to a region. 

**Reference:**
* [Microsoft Cloud Adoption Framework | Resource Naming](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)

## Resource Tagging

This project utilizes tagging conventions defined in the Azure Cloud Adoption Framework.

**Default Tags:**
* Project
* Workload
* Owner
* Environment
* Region
* ManagedBy

**Reference:**
* [Microsoft Cloud Adoption Framework | Resource Tagging](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging)
