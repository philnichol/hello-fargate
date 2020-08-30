resource "aws_cloudwatch_log_group" "svc" {
  name = "${var.name}-${var.env}"
}

resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name          = "${var.name}-${var.env}-high-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2 # 10 Minutes
  metric_name         = "CpuUtilized"
  namespace           = "ECS/ContainerInsights"
  period              = "300" # 5 minutes
  statistic           = "Average"
  threshold           = "75"
  actions_enabled     = false
  alarm_description   = "Monitors ${var.name}-${var.env} for continued high CPU percentage"

  dimensions = {
    ServiceName = "${var.name}-${var.env}"
    ClusterName = "${var.name}-${var.env}"
  }
}

resource "aws_cloudwatch_metric_alarm" "memory" {
  alarm_name          = "${var.name}-${var.env}-high-memory"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2 # 10 Minutes
  metric_name         = "MemoryUtilized"
  namespace           = "ECS/ContainerInsights"
  period              = "300" # 5 minutes
  statistic           = "Average"
  threshold           = "75"
  actions_enabled     = false
  alarm_description   = "Monitors ${var.name}-${var.env} for continued high Memory percentage"

  dimensions = {
    ServiceName = "${var.name}-${var.env}"
    ClusterName = "${var.name}-${var.env}"
  }
}

resource "aws_cloudwatch_metric_alarm" "running" {
  alarm_name          = "${var.name}-${var.env}-running-tasks"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1 # 5 Minutes
  metric_name         = "RunningTaskCount"
  namespace           = "ECS/ContainerInsights"
  period              = "300" # 5 minutes
  statistic           = "Average"
  threshold           = "1"
  actions_enabled     = false
  alarm_description   = "Monitors ${var.name}-${var.env} for <=1 running task"

  dimensions = {
    ServiceName = "${var.name}-${var.env}"
    ClusterName = "${var.name}-${var.env}"
  }
}