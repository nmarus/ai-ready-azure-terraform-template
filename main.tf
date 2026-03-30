resource "random_pet" "workload" {
  length    = 1
  separator = "-"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.effective_workload}-${var.environment}-${var.region}"
  location = var.region

  tags = local.default_tags
}

resource "azurerm_management_lock" "rg" {
  count      = contains(["prod", "staging"], var.environment) ? 1 : 0
  name       = "lock-${local.effective_workload}-${var.environment}"
  scope      = azurerm_resource_group.main.id
  lock_level = "CanNotDelete"
  notes      = "Managed by Terraform. Required for ${var.environment} environment per CAF governance."
}
