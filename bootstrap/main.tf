resource "azurerm_resource_group" "terraform_state" {
  name     = "rg-terraform-state"
  location = "centralindia"
}

resource "azurerm_storage_account" "terraform_state" {
  name                     = "tfstatebaseline2026kg01"
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public = false

  tags = {
    Project = "TerraformBaseline"
  }
}

resource "azurerm_storage_container" "terraform_state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.terraform_state.id
  container_access_type = "private"
}