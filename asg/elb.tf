resource "aws_elb" "main" {
    lifecycle { create_before_destroy = true }
    security_groups = ["${var.sg_webapp_elbs_id}"]
    subnets = [ "${split(",", var.subnet_ids)}" ]

    listener {
        instance_port = 5000
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

    health_check {
        healthy_threshold = 3
        unhealthy_threshold = 3
        timeout = 5
        target = "HTTP:5000/"
        interval = 60
    }

    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400
    cross_zone_load_balancing = true

    tags {
        Name = "${var.name_prefix}_webapp_elb"
    }
}
