variable "project" {
  description = "Project name applied to all resource tags. Defaults to 'Azure Deployment' if not defined."
  type        = string
  default     = "Azure Deployment"
}

variable "workload" {
  description = "Workload name used in resource naming. Must be lowercase alphanumeric and hyphens, 2-24 characters. Defaults to a random name if not defined."
  type        = string
  default     = null

  validation {
    condition     = var.workload == null || can(regex("^[a-z0-9][a-z0-9-]{0,22}[a-z0-9]$", var.workload))
    error_message = "workload must be 2-24 lowercase alphanumeric characters or hyphens, and cannot start or end with a hyphen."
  }
}

variable "owner" {
  description = "Name or email distribution list of the team responsible for this workload. Defaults to 'Azure Cloud Team' if not defined."
  type        = string
  default     = "Azure Cloud Team"
}

variable "environment" {
  description = "Deployment environment. Must be one of: dev, test, staging, prod. Defaults to 'dev' if not defined."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, staging, prod."
  }
}

variable "region" {
  description = "Azure region for resource deployment (e.g. 'eastus', 'westeurope'). Defaults to 'eastus' if not defined."
  type        = string
  default     = "eastus"
}

variable "additional_tags" {
  description = "Additional tags merged with the defaults. Use for workload-specific metadata such as cost center, ticket number, or compliance labels."
  type        = map(string)
  default     = {}
}
