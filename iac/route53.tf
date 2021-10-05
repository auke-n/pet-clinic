resource "aws_route53_record" "jenkins-rt53" {
  name    = "jenkins.iplatinum.pro"
  type    = "A"
  zone_id = "Z051803612ODKK7ELB6J8"

  alias {
    evaluate_target_health = true
    name                   = aws_lb.root-lb.dns_name
    zone_id                = aws_lb.root-lb.zone_id
  }
}

resource "aws_route53_record" "web-rt53" {
  name    = "petclinic.iplatinum.pro"
  type    = "A"
  zone_id = "Z051803612ODKK7ELB6J8"

  alias {
    evaluate_target_health = true
    name                   = aws_lb.web-lb.dns_name
    zone_id                = aws_lb.web-lb.zone_id
  }
}
