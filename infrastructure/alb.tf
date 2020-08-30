resource "aws_lb" "main" {
  name               = "${var.name}-${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false
}

resource "aws_alb_target_group" "main" {
  name        = "${var.name}-tg-${var.env}"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "${var.name}-${var.env}-alb-unlhealthy-hosts"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1 # 5 Minutes
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "300" # 5 minutes
  statistic           = "Average"
  threshold           = "2"
  actions_enabled     = false
  alarm_description   = "Monitors ${var.name}-${var.env}-alb for unhealthy hosts"

  dimensions = {
    TargetGroup = aws_alb_target_group.main.arn_suffix
  }
}