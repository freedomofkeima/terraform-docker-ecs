/* Security group */
output "sg_webapp_elbs_id" {
    value = "${aws_security_group.webapp_elbs.id}"
}

output "sg_webapp_instances_id" {
    value = "${aws_security_group.webapp_instances.id}"
}

/* Subnet IDs */
output "subnet_ids" {
    value = "${join(",", aws_subnet.subnet.*.id)}"
}
