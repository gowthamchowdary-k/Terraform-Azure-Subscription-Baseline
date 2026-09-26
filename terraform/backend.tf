terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatebaseline2026kg01"
    container_name       = "tfstate"
    key                  = "subscription-baseline.tfstate"
  }
}