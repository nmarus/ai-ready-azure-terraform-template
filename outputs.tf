output "project" {
  description = "Project name applied to all resource tags"
  value       = var.project
}

output "workload" {
  description = "Effective workload name used in resource naming (user-supplied or randomly generated)"
  value       = local.effective_workload
}

output "owner" {
  description = "Team or distribution list responsible for this workload"
  value       = var.owner
}

output "environment" {
  description = "Deployment environment (dev, test, staging, prod)"
  value       = var.environment
}

output "region" {
  description = "Azure region where resources are deployed"
  value       = var.region
}

output "resource_group_name" {
  description = "Name of the deployed resource group"
  value       = azurerm_resource_group.main.name
}
