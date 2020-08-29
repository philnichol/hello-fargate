resource "aws_cloudwatch_log_group" "svc" {
  name = "${var.name}-${var.env}"
}