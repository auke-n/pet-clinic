resource "aws_lb" "root-lb" {
  name               = "root-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.root-elb-sg.id]
  subnets            = [aws_subnet.subnet_build.id, aws_subnet.subnet_web.id]

  tags = {
    Name = "root-alb"
  }
}

resource "aws_lb_target_group" "root-lb-tg" {
  name        = "root-lb-tg"
  port        = 8080
  target_type = "instance"
  vpc_id      = aws_vpc.petclinic.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/login"
    port     = 8080
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "root-tg"
  }
}

resource "aws_lb_target_group_attachment" "root-attach" {
  target_group_arn = aws_lb_target_group.root-lb-tg.arn
  target_id        = aws_instance.root-server.id
  port             = 8080
}

resource "aws_lb_listener" "root-listener-https" {
  load_balancer_arn = aws_lb.root-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.jenkins.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.root-lb-tg.arn
  }
}

resource "aws_lb" "web-lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-elb-sg.id]
  subnets            = [aws_subnet.subnet_web.id, aws_subnet.subnet_build.id]

  tags = {
    Name = "web-alb"
  }
}

resource "aws_lb_target_group" "web-lb-tg" {
  name        = "app-lb-tg"
  port        = 80
  target_type = "instance"
  vpc_id      = aws_vpc.petclinic.id
  protocol    = "HTTP"
  health_check {
    enabled  = true
    interval = 10
    path     = "/login"
    port     = 80
    protocol = "HTTP"
    matcher  = "200-299"
  }
  tags = {
    Name = "web-tg"
  }
}

resource "aws_lb_target_group_attachment" "web-attach" {
  target_group_arn = aws_lb_target_group.web-lb-tg.arn
  target_id        = aws_instance.web-server.id
  port             = 80
}

resource "aws_lb_listener" "web-listener-https" {
  load_balancer_arn = aws_lb.web-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.petclinic.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-lb-tg.arn
  }

  tags = {
    Name = "web-listener"
  }
}
