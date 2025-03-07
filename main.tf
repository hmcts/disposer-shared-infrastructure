locals {
  images = []
  tags   = merge(var.common_tags, tomap({ "Team Contact" = "#disposer" }))
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = var.common_tags
}
