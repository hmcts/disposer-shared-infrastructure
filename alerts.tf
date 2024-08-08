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
  action_group_name          = "Idam User Disposer Failure Slack Alert-${var.env}"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
  enabled                    = var.enable_disposer_alerts
  common_tags                = var.common_tags
}
