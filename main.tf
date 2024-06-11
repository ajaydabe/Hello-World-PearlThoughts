resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public_subnet" {
  count         = var.subnet_count
  vpc_id        = aws_vpc.app_vpc.id
  cidr_block     = cidrsubnet(aws_vpc.app_vpc.cidr_block, 8, count.index)
  availability_zone = var.availability_zone
}

resource "aws_security_group" "ecs_service_sg" {
  name = var.ecs_service_sg_name
  description = "Security group for ECS service"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update for specific allowed IPs if needed
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_ecr_repository" "app_repository" {
  name = var.ecr_repository_name
}

resource "aws_ecs_task_definition" "hello_world_task" {
  family = var.ecs_task_definition_family
  cpu    = "256"
  memory = "512"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = <<EOF
{
  "name": "hello-world",
  "image": "${aws_ecr_repository.app_repository.arn}:latest",
  "portMappings": [
    {
      "containerPort": 80,
      "hostPort": 80
    }
  ],
  "essential": true,
  "environment": {

  }
}
EOF

  volume {
    name = "app-data"
    host {
      source_path = "/var/www/html"
    }
  }
}

resource "aws_ecs_service" "hello_world_service" {
  name = var.ecs_service_name
  cluster = aws_ecs_cluster.app_cluster.arn
  launch_type = "FARGATE"
  network_configuration {
    subnets = aws_subnet.public_subnet.*.id
    security_groups = [aws_security_group.ecs_service_sg.id]
  }
  task_definition = aws_ecs_task_definition.hello_world_task.arn
  desired_count = var.ecs_service_desired_count
  # Optional: Service Load Balancers for Public Access
  # load_balancers = [{
  #   target_group_arn = aws_lb_target_group.app_lb_target_group.arn
  #   container_name   = "hello-world"
  #   container_port   = 80
  # }]
}

# Optional: Application Load Balancer for Public Access
# resource "aws_lb" "app_lb" {
#   name = var.app_lb_name
#   internal = false
#   security_groups = [aws_security_group.ecs_service_sg.id]
#   subnets = aws_subnet.public_subnet.*.id
# }
# 
# resource "aws_lb_target_group" "app_lb_target_group" {
#   name = var.app_lb_target_group_name
#   port = 80
#   protocol = "http"
#   vpc_id = aws_vpc.app_vpc.id
# 
#   targets {
#     id = aws_ecs_service.hello_world_service.arn
#     port = 80
#     container_name = "hello-world"
#   }
# }