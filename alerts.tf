module "disposer-idam-user-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = var.env
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "Disposer Idam User Failure Slack Alert - ${var.env}"
  short_name             = "dispo-alert"
  email_receiver_name    = "Disposer Idam User Failure Alert"
  email_receiver_address = "alerts-monitoring-aaaaklvwobh6lsictm7na5t3mi@moj.org.slack.com"
}

module "disposer-idam-user-failure-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = "uksouth"
  app_insights_name    = "disposer-${var.env}"
  alert_name           = "disposer-idam-user-service-${var.env}-failure-alert"
  alert_desc           = "Alert when disposer idam user fail to run"
  app_insights_query   = "traces | where message contains 'Error executing Disposer Idam User service' | where toint(dayofweek(timestamp)/1d) < 5 "
  custom_email_subject = "Alert: Disposer idam user failure in disposer-${var.env}"
  #run daily
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.disposer-idam-user-action-group-slack.action_group_name
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.disposer_failure_enable_alerts
  common_tags                = var.common_tags
}

