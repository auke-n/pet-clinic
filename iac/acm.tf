// ---------- jenkins -----------------------
resource "aws_acm_certificate" "jenkins" {
  domain_name       = "jenkins.iplatinum.pro"
  validation_method = "DNS"

  tags = {
    Name = "jenkins"
  }
}

resource "aws_acm_certificate_validation" "jenkins-certificate" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.jenkins.arn
  validation_record_fqdns = [for record in aws_route53_record.acm-validation1 : record.fqdn]
}

resource "aws_route53_record" "acm-validation1" {
  for_each = {
    for dvo in aws_acm_certificate.jenkins.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = "Z051803612ODKK7ELB6J8"
}

// ---------- prod -----------------------

resource "aws_acm_certificate" "petclinic" {
  domain_name       = "petclinic.iplatinum.pro"
  validation_method = "DNS"

  tags = {
    Name = "petclinic"
  }
}

resource "aws_acm_certificate_validation" "petclinic-ceritficate" {
  timeouts {
    create = "5m"
  }
  certificate_arn         = aws_acm_certificate.petclinic.arn
  validation_record_fqdns = [for record in aws_route53_record.acm-validation2 : record.fqdn]
}

resource "aws_route53_record" "acm-validation2" {
  for_each = {
    for dvo in aws_acm_certificate.petclinic.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = "Z051803612ODKK7ELB6J8"
}
