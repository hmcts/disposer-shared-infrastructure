locals {
  alert_resource_group_name = "disposer-prod"
}

module "idam-user-disposer-action-group-slack-email" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "prod"
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "Idam User Disposer Slack Email Alert - ${var.env}"
  short_name             = "dispr-alert"
  email_receiver_name    = "Idam User Disposer Run Failure Alert"
  email_receiver_address = "alerts-monitoring-aaaaklvwobh6lsictm7na5t3mi@moj.org.slack.com"
}

module "idam-user-disposer-run-failure-alert" {
  source                     = "git@github.com:hmcts/cnp-module-metric-alert"
  location                   = var.location
  app_insights_name          = "disposer-${var.env}"
  alert_name                 = "${var.application_name}-${var.env}-run-failure"
  alert_desc                 = "Alert when idam user disposer fail to run"
  app_insights_query         = "traces | where message contains 'Disposer Idam User Summary :'"
  custom_email_subject       = "Alert: Idam user disposer run failure in disposer-${var.env}"
  #run every 6 hrs for early alert
  frequency_in_minutes       = "360"
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = "1440"
  severity_level             = "2"
  action_group_name          = module.idam-user-disposer-action-group-slack-email.action_group_name
  trigger_threshold_operator = "Equals"
  trigger_threshold          = "0"
  resourcegroup_name         = local.alert_resource_group_name
  enabled                    = var.enable_alerts
  common_tags                = var.common_tags
}

module "idam-user-disposer-failure-action-group-slack" {
  source                 = "git@github.com:hmcts/cnp-module-action-group"
  location               = "global"
  env                    = "prod"
  resourcegroup_name     = azurerm_resource_group.rg.name
  action_group_name      = "Idam User Disposer Failure Slack Alert - ${var.env}"
  short_name             = "fail-alert"
  email_receiver_name    = "Idam User Disposer Failure Alert"
  email_receiver_address = "alerts-monitoring-aaaaklvwobh6lsictm7na5t3mi@moj.org.slack.com"
}

module "idam-user-disposer-failure-alert" {
  source               = "git@github.com:hmcts/cnp-module-metric-alert"
  location             = var.location
  app_insights_name    = "disposer-${var.env}"
  alert_name           = "${var.application_name}-${var.env}-failure"
  alert_desc           = "Alert when idam user disposer fail"
  app_insights_query   = "traces | where message contains 'Error executing Disposer Idam User service' | where toint(dayofweek(timestamp)/1d) < 5 "
  custom_email_subject = "Alert: Idam user disposer failure-${var.env}"
  #run daily
  frequency_in_minutes = var.disposer_frequency_in_minutes
  # window of 1 day as data extract needs to run daily
  time_window_in_minutes     = var.disposer_time_window_in_minutes
  severity_level             = "2"
  action_group_name          = module.idam-user-disposer-failure-action-group-slack.action_group_name
  trigger_threshold_operator = "Equals"
  trigger_threshold          = "0"
  resourcegroup_name         = local.alert_resource_group_name
  enabled                    = var.disposer_failure_enable_alerts
  common_tags                = var.common_tags
}

