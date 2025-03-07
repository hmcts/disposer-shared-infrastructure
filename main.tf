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
  id = "https://disposer-perftest.vault.azure.net/secrets/s2s-secret-disposer-idam-user/9fe518e1f4df4e7baf808ec50a9a4009"
}