provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "aks"
  subscription_id = var.aks_infra_subscription_id
  skip_provider_registration = true
}

provider "azurerm" {
  alias           = "aks-preview"
  subscription_id = var.aks_preview_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.mgmt_subscription_id
  features {}
}