/* Instance profile which will be used in the ASG launch configuration */

output "ecs_instance_profile" {
        value = "${aws_iam_instance_profile.ecs_instance_profile.arn}"
}

/* IAM Role for ECS services */

output "ecs_service_role" {
        value = "${aws_iam_role.ecs_service_role.name}"
}
