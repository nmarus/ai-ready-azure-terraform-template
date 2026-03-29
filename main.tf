resource "azurerm_resource_group" "main" {
  name     = "rg-${local.effective_workload}-${var.environment}"
  location = var.region

  tags = merge(
    local.default_tags,
    {
      Name = "rg-${local.effective_workload}-${var.environment}"
    }
  )
}
