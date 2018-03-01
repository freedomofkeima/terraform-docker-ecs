/* Security group */
output "sg_webapp_albs_id" {
    value = "${aws_security_group.webapp_albs.id}"
}

output "sg_webapp_instances_id" {
    value = "${aws_security_group.webapp_instances.id}"
}

output "vpc_id" {
    value = "${aws_vpc.main.id}"
}

/* Subnet IDs */
output "subnet_ids" {
    value = "${join(",", aws_subnet.subnet.*.id)}"
}
