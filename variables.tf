# Project Name
variable "project" {
  description = "Project name for resource tagging. Defaults to 'Azure Deployment' if not defined."
  type        = string
  default     = "Azure Deployment"
}

# Workload name
variable "workload" {
  description = "Name of workload for resource naming. Defaults to random if not defined."
  type        = string
  default     = null
}


# Owner name
variable "owner" {
  description = "Name of owner for resource naming. Defaults to 'Azure Cloud Team' if not defined."
  type        = string
  default     = "Azure Cloud Team"
}

# Environment Name
variable "environment" {
  description = "Deployment environment. Defaults to dev if not defined."
  type        = string
  default     = "dev"
}

# Region Name
variable "region" {
  description = "Azure region to deploy resources. Defaults to eastus if not defined."
  type        = string
  default     = "eastus"
}
