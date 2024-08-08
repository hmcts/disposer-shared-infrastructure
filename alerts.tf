module "disposer-idam-user-fail-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "Disposer Idam User Fail Slack Alert - ${var.env}"
  short_name             = "dispo-idam"
  email_receiver_name    = "Disposer Idam User Service Failure Alert"
  email_receiver_address = "alerts-monitoring-aaaaklvwobh6lsictm7na5t3mi@moj.org.slack.com"
}

module "disposer-idam-user-service-failures-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "disposer-${var.env}"
  alert_name           = "disposer-idam-user-service-${var.env}-failures-alert"
  alert_desc           = "Triggers when disposer idam user service fail to run"
  app_insights_query   = "traces | where message contains 'Error executing Disposer Idam User service' | where toint(dayofweek(timestamp)/1d) < 5"
  custom_email_subject = "Alert: Disposer Idam User Service failure in disposer-${var.env}"
  ##run every day ad disposer runs only once
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as disposer run daily once
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.disposer-idam-user-fail-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.enable_disposer_alerts
  common_tags                = var.common_tags
}
