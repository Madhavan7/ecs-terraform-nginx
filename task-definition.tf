terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ecs_task_definition" "nginx_task_definition"{
  family = "nginx-task-definition"
  requires_compatibilities = [ "FARGATE" ]
  network_mode             = "awsvpc"
  cpu = 1024
  memory = 2048
  
  container_definitions = file("container-definition.json")

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}
