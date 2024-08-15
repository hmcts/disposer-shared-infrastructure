module "disposer-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "disposer-${var.env}"
  product                 = var.product
  env                     = var.env
  tenant_id               = var.tenant_id
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_name      = "DTS Retain and Dispose"
  common_tags             = var.common_tags
  create_managed_identity = true
}


data "azurerm_key_vault" "disposer_vault" {
  name                = module.disposer-vault.key_vault_name
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_key_vault" "s2s_vault" {
  name                = "s2s-${var.env}"
  resource_group_name = "rpe-service-auth-provider-${var.env}"
}

data "azurerm_key_vault_secret" "key_from_s2s_vault" {
  name         = "microservicekey-disposer-idam-user"
  key_vault_id = data.azurerm_key_vault.s2s_vault.id
}

resource "azurerm_key_vault_secret" "s2s" {
  name         = "s2s-secret-disposer-idam-user"
  value        = data.azurerm_key_vault_secret.key_from_s2s_vault.value
  key_vault_id = data.azurerm_key_vault.disposer_vault.id
}

output "vaultName" {
  value = module.disposer-vault.key_vault_name
}

data "azurerm_key_vault_secret" "idamUserDisposerSummaryAlertEmail" {
  name         = "idamUserDisposerSummaryAlertEmail"
  key_vault_id = data.azurerm_key_vault.disposer_vault.id
}

data "azurerm_key_vault_secret" "idamUserDisposerAlertEmail" {
  name         = "idamUserDisposerAlertEmail"
  key_vault_id = data.azurerm_key_vault.disposer_vault.id
}