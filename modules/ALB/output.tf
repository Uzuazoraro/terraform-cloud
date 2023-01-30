output "alb_dns_name" {
  value = aws_lb.ext-alb.dns_name
  description = "external load balancer arn"
}

output "nginx-tgt" {
  value = aws_lb_target_group.nginx-tgt.arn
  description = "external load balancer target group"
}

output "wordpress-tgt" {
  value = aws_lb_target_group.wordpress-tgt.arn
  description = "wordpress target group"
}

output "tooling-tgt" {
  value = aws_lb_target_group.tooling-tgt.arn
  description = "tooling target group"
}