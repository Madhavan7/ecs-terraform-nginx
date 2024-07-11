terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "account_number"{}

resource "aws_ecs_task_definition" "nginx_task_definition"{
  family = "nginx-task-definition"
  requires_compatibilities = [ "FARGATE" ]
  network_mode             = "awsvpc"
  cpu = 1024
  memory = 2048

  container_definitions = jsonencode([
  {
    "name": "app",  
    "image": "${var.account_number}.dkr.ecr.ca-central-1.amazonaws.com/nginx:latest",  
    "cpu": 1024,
    "memory": 2048,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8081,
        "hostPort": 8081,
        "protocol": "tcp"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/my-task",
        "awslogs-region": "ca-central-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
])

  execution_role_arn = "arn:aws:iam::${var.account_number}:role/ecsTaskExecutionRole"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
