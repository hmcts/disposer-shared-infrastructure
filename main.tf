locals {
  images = []
  tags   = merge(var.common_tags, tomap({ "Team Contact" = "#disposer" }))
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = var.common_tags
}


# Obtain the subscription ID of the problematic resource
data "azurerm_subscription" "current" {}

import {
  # Run this import only in perftest
  for_each = var.env == "perftest" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = azurerm_key_vault_secret.s2s
  # Specify the resource ID to import from
  id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/disposer-perftest/providers/Microsoft.KeyVault/vaults/disposer-perftest/secrets/s2s-secret-disposer-idam-user"
}