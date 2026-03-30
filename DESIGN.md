# Design

This document defines the design standards that this project follows.

## Naming Conventions

This project utilizes naming conventions defined in the Azure Cloud Adoption Framework.

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
