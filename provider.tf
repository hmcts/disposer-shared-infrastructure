provider "azurerm" {
  features {}
}

provider "azurerm" {
  features {}
  alias           = "aks"
  subscription_id = var.aks_subscription_id
  skip_provider_registration = false
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