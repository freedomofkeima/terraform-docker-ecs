/**
  * DNS name from ELB
  * In production, you can add this DNS Name to Route 53 (your domain)
  */
output "elb_dns_name" {
    value = "${aws_elb.main.dns_name}"
}
