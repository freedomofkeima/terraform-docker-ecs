/**
  * DNS name from ALB
  * In production, you can add this DNS Name to Route 53 (your domain)
  */
output "alb_dns_name" {
    value = "${aws_alb.main.dns_name}"
}
