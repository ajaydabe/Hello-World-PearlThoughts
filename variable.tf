variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "subnet_count" {
  type = number
  default = 2
  description = "Number of public subnets in the VPC"
}

variable "availability_zone" {
  type = string
  default = "us-east-1a"
  description = "Availability Zone for the resources"
}

variable "security_group_name" {
  type = string
  default = "hello-world-security-group"
  description = "Name of the security group for the application"
}

variable "cluster_name" {
  type = string
  default = "hello-world-cluster"
  description = "Name of the ECS cluster"
}

variable "repository_name" {
  type = string
  default = "hello-world-app"
  description = "Name of the ECR repository for the application image"
}

variable "task_definition_family" {
  type = string
  default = "hello-world-task-definition"
  description = "Family name for the ECS task definition"
}

variable "desired_count" {
  type = number
  default = 1
  description = "Desired number of tasks running in the ECS service"
}