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

/* Region settings for AWS provider */
provider "aws" {
    region = "${var.aws_region}"
}
