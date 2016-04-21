/**
  * We will utilize ELB and allow web access only from ELB
  */
resource "aws_security_group" "webapp_elbs" {
    name = "${var.name_prefix}-webapp-elbs"
    vpc_id = "${aws_vpc.main.id}"
    description = "Security group for ELBs"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.name_prefix}-webapp"
    }
}

/**
  * Security group for each instances
  */
resource "aws_security_group" "webapp_instances" {
    name = "${var.name_prefix}-webapp-instances"
    vpc_id = "${aws_vpc.main.id}"
    description = "Security group for instances"

    tags {
        Name = "${var.name_prefix}-webapp"
    }
}

/* Allow all outgoing connections */
resource "aws_security_group_rule" "allow_all_egress" {
    type = "egress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.webapp_instances.id}"
}

/* Allow incoming requests from ELB and peers only */
resource "aws_security_group_rule" "allow_all_from_elbs" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"

    security_group_id = "${aws_security_group.webapp_instances.id}"
    source_security_group_id = "${aws_security_group.webapp_elbs.id}"
}

resource "aws_security_group_rule" "allow_all_from_peers" {
    type = "ingress"
    from_port = 0
    to_port = 0
    protocol = "-1"

    security_group_id = "${aws_security_group.webapp_instances.id}"
    source_security_group_id = "${aws_security_group.webapp_instances.id}"
}

/**
  * In production, it's recommended to remove SSH access to the instance
  * (Comment the following lines out)
  */
resource "aws_security_group_rule" "allow_ssh_from_internet" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_group_id = "${aws_security_group.webapp_instances.id}"
}
