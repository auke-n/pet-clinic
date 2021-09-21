resource "aws_lb" "jenkins-lb" {
  name               = "jenkins-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.jenkins-elb-sg.id]
  subnets            = [aws_subnet.subnet_build.id, aws_subnet.subnet_prod.id]

  tags = {
    Name = "jenkins-alb"
  }
}

resource "aws_lb_target_group" "jenkins-lb-tg" {
  name        = "jenkins-lb-tg"
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
    Name = "jenkins-tg"
  }
}

resource "aws_lb_target_group_attachment" "jenkins-attach" {
  target_group_arn = aws_lb_target_group.jenkins-lb-tg.arn
  target_id        = aws_instance.jenkins-server.id
  port             = 8080
}

resource "aws_lb_listener" "jenkins-listener-https" {
  load_balancer_arn = aws_lb.jenkins-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.jenkins.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-lb-tg.arn
  }
}

resource "aws_lb" "prod-lb" {
  name               = "prod-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-elb-sg.id]
  subnets            = [aws_subnet.subnet_prod.id, aws_subnet.subnet_build.id]

  tags = {
    Name = "prod-alb"
  }
}

resource "aws_lb_target_group" "prod-lb-tg" {
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
    Name = "prod-tg"
  }
}

resource "aws_lb_target_group_attachment" "prod-attach" {
  target_group_arn = aws_lb_target_group.prod-lb-tg.arn
  target_id        = aws_instance.prod-server.id
  port             = 80
}

resource "aws_lb_listener" "prod-listener-https" {
  load_balancer_arn = aws_lb.prod-lb.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.petclinic.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod-lb-tg.arn
  }

  tags = {
    Name = "prod-listener"
  }
}
