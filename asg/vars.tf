/* Terraform constraints */
terraform {
    required_version = ">= 0.11, < 0.12"
}

variable "name_prefix" {
    default = "tutorial"
    description = "Name prefix for this environment."
}

variable "aws_region" {
    default = "ap-northeast-1"
    description = "Determine AWS region endpoint to access."
}

/* ECS optimized AMIs per region */
variable "ecs_image_id" {
  # ami-2017.09.i with ECS Agent 1.17.1-1 and Docker 17.09.1-ce
  default = {
    ap-northeast-1 = "ami-68ef940e"
    ap-southeast-1 = "ami-0a622c76"
    eu-west-1      = "ami-0693ed7f"
    us-east-1      = "ami-a7a242da"
    us-west-1      = "ami-9ad4dcfa"
    us-west-2      = "ami-92e06fea"
  }
  description = "ECS Optimized AMI. Not used with launch_type FARGATE."
}

variable "webapp_docker_image_name" {
    default = "training/webapp_docker_image"
    description = "Docker image from Docker Hub"
}

variable "webapp_docker_image_tag" {
    default = "latest"
    description = "Docker image version to pull (from tag)"
}

variable "count_webapp" {
    default = 2
    description = "Number of webapp tasks to run"
}

variable "desired_capacity_on_demand" {
    default = 2
    description = "Number of instances to run. Not used with launch_type FARGATE"
}

variable "launch_type" {
    default = "EC2"
    description = "launch type. set to FARGATE to use fargate. default is EC2 launch type."
}

variable "ec2_key_name" {
    default = ""
    description = "EC2 key name to SSH to the instance, make sure that you have this key if you want to access your instance via SSH"
}

variable "instance_type" {
    default = "t2.micro"
    description = "EC2 instance type to use. Not used with launch_type FARGATE"
}

variable "minimum_healthy_percent_webapp" {
    default = 50
    description = "ECS minimum_healthy_percent configuration, set it lower than 100 to allow rolling update without adding new instances"
}

/* Consume common outputs */
variable "sg_webapp_albs_id" {}
variable "sg_webapp_instances_id" {}
variable "vpc_id" {}
variable "subnet_ids" {}

/* Consume static outputs */
variable "ecs_instance_profile" {}
variable "ecs_service_role" {}
variable "ecs_task_execution_role" {}


/* Region settings for AWS provider */
provider "aws" {
    region = "${var.aws_region}"
}
