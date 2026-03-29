output "project" {
  description = "The project name being used"
  value       = var.project
}

output "workload" {
  description = "The workload name being used"
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

# testing
output "azurerm_client_config" {
  description = "The current client configuration"
  value       = data.azurerm_client_config.current
}
