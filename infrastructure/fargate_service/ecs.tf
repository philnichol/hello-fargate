resource "aws_ecs_cluster" "cluster" {
  count = var.cluster_id == null ? 1 : 0
  name  = "${var.name}-${var.env}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data "template_file" "container_definition" {
  template = file("${path.module}/templates/container_def_template.json")

  vars = {
    image_url           = "${var.repo_url}:${var.image_tag}"
    name                = var.name
    env                 = var.env
    cpu                 = var.cpu
    memory              = var.memory
    log_group_name      = "${var.name}-${var.env}"
    log_group_region    = var.region
    greeting            = var.greeting
    time_format         = var.time_format
    port                = var.container_port
    healthcheck_command = var.healthcheck_command
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "${var.name}-${var.env}"
  container_definitions    = data.template_file.container_definition.rendered
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.exec.arn
  task_role_arn            = aws_iam_role.task.arn
}

resource "aws_ecs_service" "svc" {
  name                               = "${var.name}-${var.env}"
  cluster                            = var.cluster_id == null ? aws_ecs_cluster.cluster[0].id : var.cluster_id
  task_definition                    = aws_ecs_task_definition.task.arn
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds  = 15
  launch_type                        = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.name
    container_port   = var.container_port
  }

  network_configuration {
    security_groups  = var.ecs_sgs_id
    subnets          = var.ecs_subnet_ids
    assign_public_ip = false
  }
}