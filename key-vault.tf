module "disposer-vault" {
  source                     = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                       = "disposer-${var.env}"
  product                    = var.product
  env                        = var.env
  tenant_id                  = var.tenant_id
  object_id                  = var.jenkins_AAD_objectId
  resource_group_name        = azurerm_resource_group.rg.name
  product_group_name         = "DTS Retain and Dispose"
  common_tags                = var.common_tags
  create_managed_identity    = true
}

output "vaultName" {
  value = module.disposer-vault.key_vault_name
}