/* Cluster definition, which is used in autoscaling.tf */
resource "aws_ecs_cluster" "webapp_cluster" {
    name = "${var.name_prefix}_webapp_cluster"
}

/* ECS service definition */
resource "aws_ecs_service" "webapp_service" {
    count = "${var.launch_type == "FARGATE" ? 0 : 1}"
    name = "${var.name_prefix}_webapp_service"
    cluster = "${aws_ecs_cluster.webapp_cluster.id}"
    task_definition = "${aws_ecs_task_definition.webapp_definition.arn}"
    desired_count = "${var.count_webapp}"
    deployment_minimum_healthy_percent = "${var.minimum_healthy_percent_webapp}"
    iam_role = "${var.ecs_service_role}"

    load_balancer {
        target_group_arn = "${aws_alb_target_group.webapp_tg.arn}"
        container_name = "webapp"
        container_port = 5000
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_ecs_service" "webapp_service_fargate" {
    count = "${var.launch_type == "FARGATE" ? 1 : 0}"
    name = "${var.name_prefix}_webapp_service"
    cluster = "${aws_ecs_cluster.webapp_cluster.id}"
    task_definition = "${aws_ecs_task_definition.webapp_definition_fargate.arn}"
    launch_type = "FARGATE"
    desired_count = "${var.count_webapp}"
    deployment_minimum_healthy_percent = "${var.minimum_healthy_percent_webapp}"
    iam_role = "${var.ecs_service_role}"

    network_configuration {
        security_groups = ["${var.sg_webapp_instances_id}"]
        subnets         = ["${split(",", var.subnet_ids)}"]
    }

    load_balancer {
        target_group_arn = "${aws_alb_target_group.webapp_tg.arn}"
        container_name = "webapp"
        container_port = 5000
    }

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_ecs_task_definition" "webapp_definition" {
    count = "${var.launch_type == "FARGATE" ? 0 : 1}"
    family = "${var.name_prefix}_webapp"
    container_definitions = "${data.template_file.task_webapp.rendered}"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_ecs_task_definition" "webapp_definition_fargate" {
    count = "${var.launch_type == "FARGATE" ? 1 : 0}"
    family = "${var.name_prefix}_webapp"
    container_definitions = "${data.template_file.task_webapp.rendered}"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    execution_role_arn = "${var.ecs_task_execution_role}"
    cpu = "512"
    memory = "1024"

    lifecycle {
        create_before_destroy = true
    }
}

data "template_file" "task_webapp" {
    template= "${file("task-definitions/ecs_task_webapp.tpl")}"

    vars {
        webapp_docker_image = "${var.webapp_docker_image_name}:${var.webapp_docker_image_tag}"
    }
}
