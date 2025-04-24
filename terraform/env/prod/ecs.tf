locals {
  app_name           = "alma-interview-prod"
  app_container_name = "alma-interview-prod-container"
  app_service_name   = "alma-interview-prod-service"
  app_container_port = 5000

  app_tags = {
    Name = local.app_name
  }
}


## Cluster
module "app-prod-ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "5.8.0"

  cluster_name = local.app_name

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        capacity_provider = "FARGATE"
        weight            = 1
        base              = 1
      }
    }
  }

  tags = local.app_tags
}

## Service
module "app-prod-ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.8.0"

  name        = local.app_service_name
  cluster_arn = module.app-prod-ecs.cluster_arn

  desired_count            = 1
  autoscaling_min_capacity = 1

  enable_execute_command = true
  cpu                    = 1024
  memory                 = 2048

  create_tasks_iam_role     = true
  create_task_exec_iam_role = true

  container_definitions = {
    (local.app_container_name) = {
      cpu       = 512
      memory    = 1024
      essential = true
      image     = var.app_prod_image

      port_mappings = [
        {
          name          = local.app_container_name
          containerPort = local.app_container_port
          hostPort      = local.app_container_port
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "ENVIRONMENT"
          value = "production"
        }
      ]

      secrets = [
        {
          name      = "USERNAME"
          valueFrom = "${module.generate_application_user_name.generated_secret_arn}:USERNAME::"
        },
        {
          name      = "PASSWORD"
          valueFrom = "${module.generate_application_password.generated_secret_arn}:PASSWORD::"
        },
        {
          name      = "API_KEY"
          valueFrom = "${module.generate_application_api_key.generated_secret_arn}:API_KEY::"
        }
      ]

      readonly_root_filesystem = false
      user                     = 1001
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.app-prod-alb.target_groups["ex_ecs"].arn
      container_name   = local.app_container_name
      container_port   = local.app_container_port
    }
  }

  subnet_ids = module.vpc-app-prod-eu.private_subnets
  security_group_rules = {
    alb_ingress_5000 = {
      type                     = "ingress"
      from_port                = local.app_container_port
      to_port                  = local.app_container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.app-prod-alb.security_group_id
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}


## ALB
module "app-prod-alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = local.app_name

  load_balancer_type = "application"

  vpc_id  = module.vpc-app-prod-eu.vpc_id
  subnets = module.vpc-app-prod-eu.public_subnets

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc-app-prod-eu.vpc_cidr_block
    }
  }

  listeners = {
    ex_http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "ex_ecs"
      }
    }
  }

  target_groups = {
    ex_ecs = {
      backend_protocol                  = "HTTP"
      backend_port                      = local.app_container_port
      target_type                       = "ip"
      deregistration_delay              = 5
      load_balancing_cross_zone_enabled = true

      health_check = {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
      }

      create_attachment = false
    }
  }

  tags = local.app_tags
}