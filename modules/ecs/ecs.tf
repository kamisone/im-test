resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  family = var.task_family_name
  container_definitions = jsonencode(
    [
      {
        "name" : "${var.task_name}",
        "image" : "${var.ecr_repo_url}"
        "essential" : true,
        "portMappings" : [
          {
            "containerPort" : "${var.container_port}"
            "hostPort" : "${var.container_port}"
          }
        ],
        "logConfiguration" = {
          "logDriver" = "awslogs"
          "options" = {
            "awslogs-group"         = "${aws_cloudwatch_log_group.ecs_log-group.name}"
            "awslogs-region"        = "eu-west-3",
            "awslogs-stream-prefix" = "ecs"
          }
        },
        "environment" = concat(
          [
          for line in split("\n", data.local_file.env_file.content) : {
            name  = split("=", line)[0]
            value = split("=", line)[1]
          }
        ],
        [
          {
            name  = "DATABASE_HOST"
            value = var.db_address
          } 
        ]
        ),
        "secrets" = [
          {
            name      = "API_TOKEN_SALT",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:API_TOKEN_SALT::"
          },
          {
            name      = "ADMIN_JWT_SECRET",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:ADMIN_JWT_SECRET::"
          },
          {
            name      = "TRANSFER_TOKEN_SALT",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:TRANSFER_TOKEN_SALT::"
          },
          {
            name      = "JWT_SECRET",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:JWT_SECRET::"
          },
          {
            name      = "DATABASE_USERNAME",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:DATABASE_USERNAME::"
          },
          {
            name      = "DATABASE_PASSWORD",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:DATABASE_PASSWORD::"
          },
          {
            name      = "SMTP_USERNAME",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:SMTP_USERNAME::"
          },
          {
            name      = "SMTP_PASSWORD",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:SMTP_PASSWORD::"
          },

          {
            name      = "AWS_ACCESS_KEY_ID",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:AWS_ACCESS_KEY_ID::"
          },
          {
            name      = "AWS_SECRET_ACCESS_KEY",
            valueFrom = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn:AWS_SECRET_ACCESS_KEY::"
          }
        ]
      }
    ]
  )

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}


resource "aws_iam_role" "ecs_task_execution_role" {
  name               = var.ecs_task_exection_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_policy" "ecs_secrets_manager_policy" {
  name = "ecs-secrets-manager-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Effect   = "Allow"
        Resource = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn"
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_access_policy" {
  name = "ecr-access-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

}
resource "aws_iam_role_policy" "cloudwatch_task_access_iam_role_policy" {
  name = "cloudwatch-task-access-dev"
  role = aws_iam_role.ecs_task_execution_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "${aws_cloudwatch_log_group.ecs_log-group.arn}:*"
      }
    ]
  })

}



resource "aws_secretsmanager_secret_policy" "secret_policy" {
  secret_arn = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "${aws_iam_role.ecs_task_execution_role.arn}"
        },
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "arn:aws:secretsmanager:eu-west-3:794038237190:secret:impactes-mobile-dev-r510fn"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attach_secrets" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_secrets_manager_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_attach_ecr" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn

}

resource "aws_alb" "application_load_balancer" {

  name               = var.application_load_balancer_name
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = ["${var.alb_security_group_id}"]

  depends_on = [ var.igw_id ]
}


resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.aws_vpc_id

  health_check {
    path                = "/admin/auth/register-admin"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

}


resource "aws_ecs_service" "ecs_service" {
  name                              = var.ecs_service_name
  cluster                           = aws_ecs_cluster.ecs_cluster.id
  task_definition                   = aws_ecs_task_definition.ecs_task_definition.arn
  launch_type                       = "FARGATE"
  desired_count                     = 1
  health_check_grace_period_seconds = 300


  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = lookup(jsondecode(aws_ecs_task_definition.ecs_task_definition.container_definitions)[0], "name")
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = ["${var.ecs_security_group_id}"]
  }
}

// logs (CloudWatch)
resource "aws_cloudwatch_log_group" "ecs_log-group" {
  name              = var.cloudwatch_group_name
  retention_in_days = 30

  tags = {
    Name = "ecs-log-group"
  }
}


# Local data
data "local_file" "env_file" {
  filename = "${path.module}/dev.env"

}


# outputs
output "load_balancer_dns_name" {
  value = aws_alb.application_load_balancer.dns_name
}
output "load_balancer_name" {
  value = aws_alb.application_load_balancer.name
}

output "load_balancer_arn" {
  value = aws_alb.application_load_balancer.arn
}