terraform {
  required_version = ">= 1.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.8"
    }
  }

  # Local backend — suitable for development and single-developer use.
  # For enterprise deployments, replace with the azurerm backend below
  # to enable remote state storage with locking via Azure Blob Storage.
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      # Prevents accidental deletion of resource groups that still contain
      # resources during terraform destroy. Set to false only when intentional
      # bulk teardown is required.
      prevent_deletion_if_contains_resources = true
    }
  }
}

# ---------------------------------------------------------------------------
# Enterprise Remote State Backend (Azure Blob Storage)
# ---------------------------------------------------------------------------
# Replace the backend "local" block above with the configuration below to
# enable shared remote state with state locking. Create the storage account
# and container before switching backends, then run: terraform init -migrate-state
#
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "<tfstate-resource-group>"
#     storage_account_name = "<tfstate-storage-account>"
#     container_name       = "tfstate"
#     key                  = "<workload>/<environment>.terraform.tfstate"
#   }
# }
