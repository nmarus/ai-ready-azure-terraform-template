resource "random_pet" "workload" {
  length    = 1
  separator = "-"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.effective_workload}-${var.environment}-${var.region}"
  location = var.region

  tags = merge(
    local.default_tags,
    {
      Name = "rg-${local.effective_workload}-${var.environment}-${var.region}"
    }
  )
}
