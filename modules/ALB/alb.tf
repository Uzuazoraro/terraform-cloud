# External Load Balancer for reverse proxy Nginx

resource "aws_lb" "ext-alb" {
  name     = "ext-alb"
  internal = false
  security_groups = [var.public-sg]

  subnets = [var.public-sbn-1,
  var.public-sbn-2]

  tags = merge (
    var.tags,
    {
      Name = var.name
    },
  )

  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}

# Create a Target Group for the external ALB.

resource "aws_lb_target_group" "nginx-tgt" {
  health_check {
    interval            = var.lb_interval #10
    path                = "/healthstatus"
    protocol            = var.tgt_protocol # "HTTPS"
    timeout             = var.lb_timeout #5
    healthy_threshold   = var.lb_healthy_threshold #5
    unhealthy_threshold = var.lb_unhealthy_threshold #2
  }
  name        = "nginx-tgt"
  port        = var.tgt_port #443
  protocol    = var.tgt_protocol # "HTTPS"
  target_type = var.tgt_target_type # "instance"
  vpc_id      = var.vpc_id
}

# Create Listener to listen to ALB

resource "aws_lb_listener" "nginx-listener" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = var.listener_port #443
  protocol          = var.listener_protocol # "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.zireuz.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tgt.arn
  }
}

# Create an Internal (Internal) Application Load Balancer (ALB)

# ----------------------------
#Internal Load Balancers for webservers
#---------------------------------

resource "aws_lb" "ialb" {
  name     = "ialb"
  internal = true
  security_groups = [var.private-sg]

  subnets = [
    var.vpc_subnet.private[0].id,
    var.vpc_subnet.private[1].id
  ]

  tags = {
    Name = var.name
  }


  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}

# Create a target group to point to its target

# --- target group  for wordpress -------

resource "aws_lb_target_group" "wordpress-tgt" {
  health_check {
    interval            = var.lb_interval #10
    path                = "/healthstatus"
    protocol            = var.tgt_protocol # "HTTPS"
    timeout             = var.lb_timeout #5
    healthy_threshold   = var.lb_healthy_threshold #5
    unhealthy_threshold = var.lb_unhealthy_threshold #2

  }

  name        = "wordpress-tgt"
  port        = var.tgt_port #443
  protocol    = var.tgt_protocol # "HTTPS"
  target_type = var.tgt_target_type # "instance"
  vpc_id      = var.vpc_id
}

# --- target group for tooling -------

resource "aws_lb_target_group" "tooling-tgt" {
  health_check {
    interval            = var.lb_interval #10
    path                = "/healthstatus"
    protocol            = var.tgt_protocol # "HTTPS"
    timeout             = var.lb_timeout #5
    healthy_threshold   = var.lb_healthy_threshold #5
    unhealthy_threshold = var.lb_unhealthy_threshold #2

  }

  name        = "tooling-tgt"
  port        = var.tgt_port #443
  protocol    = var.tgt_protocol # "HTTPS"
  target_type = var.tgt_target_type # "instance"
  vpc_id      = var.vpc_id
}

# Create a Listener to listen to this target group

# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.ialb.arn
  port              = var.listener_port #443
  protocol          = var.listener_protocol #"HTTPS"
  certificate_arn   = aws_acm_certificate_validation.zireuz.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress-tgt.arn
  }
}

# listener rule for tooling target

resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tooling-tgt.arn
  }

  condition {
    host_header {
      values = ["tooling.zireuz.ga"]
    }
  }
}