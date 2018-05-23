resource "aws_launch_configuration" "webapp_on_demand" {
    count = "${var.launch_type == "FARGATE" ? 0 : 1}"
    instance_type = "${var.instance_type}"
    image_id = "${lookup(var.ecs_image_id, var.aws_region)}"
    iam_instance_profile = "${var.ecs_instance_profile}"
    user_data = "${data.template_file.autoscaling_user_data.rendered}"
    key_name = "${var.ec2_key_name}"
    security_groups = ["${var.sg_webapp_instances_id}"]
    associate_public_ip_address = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "webapp_on_demand" {
    count = "${var.launch_type == "FARGATE" ? 0 : 1}"
    name = "${var.name_prefix}_webapp_on_demand"
    max_size = 50
    min_size = 0
    desired_capacity = "${var.desired_capacity_on_demand}"
    health_check_grace_period = 300
    health_check_type = "EC2"
    force_delete = true
    launch_configuration = "${aws_launch_configuration.webapp_on_demand.name}"
    vpc_zone_identifier = ["${split(",", var.subnet_ids)}"]

    tag {
        key = "Name"
        value = "${var.name_prefix}-webapp-on-demand"
        propagate_at_launch = true
    }

    lifecycle {
        create_before_destroy = true
    }
}

data "template_file" "autoscaling_user_data" {
    count = "${var.launch_type == "FARGATE" ? 0 : 1}"
    template = "${file("autoscaling_user_data.tpl")}"
    vars {
        ecs_cluster = "${aws_ecs_cluster.webapp_cluster.name}"
    }
}
