output "project" {
  description = "The project name being used"
  value       = var.project
}

output "workload" {
  description = "The effective workload name being used (user-supplied or randomly generated)"
  value       = local.effective_workload
}

output "owner" {
  description = "The owner name being used"
  value       = var.owner
}

output "environment" {
  description = "The deployment environment being used"
  value       = var.environment
}

output "region" {
  description = "The Azure region being used"
  value       = var.region
}

output "resource_group_name" {
  description = "The name of the deployed resource group"
  value       = azurerm_resource_group.main.name
}
