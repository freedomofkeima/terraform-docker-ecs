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
  # ami-2015.09.g with ECS Agent 1.8.1 and Docker 1.9.1
  default = {
    ap-northeast-1 = "ami-b3afa2dd"
    ap-southeast-1 = "ami-0cb0786f"
    eu-west-1      = "ami-77ab1504"
    us-east-1      = "ami-33b48a59"
    us-west-1      = "ami-26f78746"
    us-west-2      = "ami-65866a05"
  }
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
    description = "Number of instance to run"
}

variable "ec2_key_name" {
    default = ""
    description = "EC2 key name to SSH to the instance, make sure that you have this key if you want to access your instance via SSH"
}

variable "instance_type" {
    default = "t2.micro"
    description = "EC2 instance type to use"
}

variable "minimum_healthy_percent_webapp" {
    default = 50
    description = "ECS minimum_healthy_percent configuration, set it lower than 100 to allow rolling update without adding new instances"
}

/* Consume common outputs */
variable "sg_webapp_elbs_id" {}
variable "sg_webapp_instances_id" {}
variable "subnet_ids" {}

/* Consume static outputs */
variable "ecs_instance_profile" {}
variable "ecs_service_role" {}

/* Region settings for AWS provider */
provider "aws" {
    region = "${var.aws_region}"
}
