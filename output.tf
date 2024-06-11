output "ecs_cluster_arn" {
  value = aws_ecs_cluster.app_cluster.arn
  description = "ARN of the ECS cluster"
}

output "ecs_service_arn" {
  value = aws_ecs_service.app_service.arn
  description = "ARN of the ECS service"
}

output "security_group_id" {
  value = aws_security_group.app_security_group.id
  description = "ID of the security group for the application"
}