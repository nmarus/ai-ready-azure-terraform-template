# Design

This document defines the design standards that this project follows.

## Naming Conventions

This project utilizes naming conventions defined in the Azure Cloud Adoption Framework.

`<resource-type>-<workload>-[component]-<environment>-<region>`

Parameters in `[brackets]` are optional:

| Parameter | Required | Description |
|---|---|---|
| `resource-type` | Yes | Azure resource type abbreviation (e.g. `rg`, `st`, `vnet`, `kv`) |
| `workload` | Yes | Workload name — use `local.effective_workload` |
| `component` | **No** | Only include when a workload deploys **multiple resources of the same type** to distinguish them |
| `environment` | Yes | Deployment environment (e.g. `dev`, `prod`) — use `var.environment` |
| `region` | Yes | Azure region (e.g. `eastus`) — use `var.region` |

**Single resource of a type** (omit `component`):
```
rg-myapp-prod-eastus
st-myapp-prod-eastus
kv-myapp-prod-eastus
```

**Multiple resources of the same type** (include `component` to distinguish):
```
st-myapp-logs-prod-eastus
st-myapp-data-prod-eastus
```

**Reference:**
* [Microsoft Cloud Adoption Framework | Resource Naming](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
* [Azure resource abbreviations](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)

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
