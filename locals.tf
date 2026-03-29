locals {
  effective_workload = var.workload == null ? random_pet.workload.id : var.workload

  default_tags = merge(
    {
      Project     = var.project
      Workload    = local.effective_workload
      Owner       = var.owner
      Environment = var.environment
      Region      = var.region
      ManagedBy   = "Terraform"
    },
    var.additional_tags
  )
}
