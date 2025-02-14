module "idam-user-disposer-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "Idam User Disposer Failure Slack Alert - ${var.env}"
  short_name             = "disp-alert"
  email_receiver_name    = "Idam User Disposer Failure Alert"
  email_receiver_address = data.azurerm_key_vault_secret.idamUserDisposerAlertEmail.value
}

module "idam-user-disposer-service-failure-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "disposer-${var.env}"
  alert_name           = "idam-user-disposer-service-${var.env}-failure"
  alert_desc           = "Alert when idam user disposer fail to run"
  app_insights_query   = "traces | where message contains 'Error executing Disposer Idam User service' | where toint(dayofweek(timestamp)/1d) < 6"
  custom_email_subject = "Alert: Idam user disposer failure in disposer-${var.env}"
  #run every day as Idam disposer runs only once
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.idam-user-disposer-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.disposer_failure_enable_alerts
  common_tags                = var.common_tags
}

module "idam-user-disposer-summary-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "Idam User Disposer Summary Slack Alert - ${var.env}"
  short_name             = "idam-user"
  email_receiver_name    = "Idam User Disposer Summary Alert"
  email_receiver_address = data.azurerm_key_vault_secret.idamUserDisposerSummaryAlertEmail.value
}

module "idam-user-disposer-service-summary-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "disposer-${var.env}"
  alert_name           = "idam-user-disposer-service-${var.env}-summary"
  alert_desc           = "Alert when idam user disposer run and present summary"
  app_insights_query   = "traces | where message contains 'Disposer Idam User Summary' | where toint(dayofweek(timestamp)/1d) < 6"
  custom_email_subject = "Alert: Idam user disposer Summary in disposer-${var.env}"
  #run every day as Idam User disposer runs only once
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.idam-user-disposer-summary-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.disposer_summary_enable_alerts
  common_tags                = var.common_tags
}

