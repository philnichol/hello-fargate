data "aws_caller_identity" "current" {}

module "vpc" {
  source          = "./vpc"
  name            = var.name
  env             = var.env
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "fargate" {
  source           = "./fargate_service"
  name             = var.name
  env              = var.env
  target_group_arn = aws_alb_target_group.main.arn
  ecs_sgs_id       = [aws_security_group.ecs.id]
  ecs_subnet_ids   = module.vpc.private_subnets
  repo_url         = aws_ecr_repository.ecr.repository_url
  image_tag        = var.image_tag
}