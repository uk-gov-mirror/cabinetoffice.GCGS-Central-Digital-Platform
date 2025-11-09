resource "aws_route53_record" "services_to_alb" {
  for_each = local.service_configs

  zone_id = var.public_hosted_zone_id
  name    = each.value.name
  type    = "CNAME"
  ttl     = 60

  records = each.value.cluster == "sirsi-php" ?  [aws_lb.ecs_php.dns_name] :  [aws_lb.ecs.dns_name]
}

resource "aws_route53_record" "cfs_services_to_alb" {
  for_each = toset(var.cfs_extra_domains)

  zone_id = var.public_hosted_zone_cfs_id
  name    = each.value
  type    = "CNAME"
  ttl     = 60

  records = [aws_lb.ecs_php.dns_name]
}

resource "aws_route53_record" "fts_services_to_alb" {
  for_each = toset(var.fts_extra_domains)

  zone_id = var.public_hosted_zone_fts_id
  name    = each.value
  type    = "CNAME"
  ttl     = 60

  records = [aws_lb.ecs_php.dns_name]
}

resource "aws_route53_record" "main_entrypoint_alias" {

  name    = var.public_domain
  type    = "A"
  zone_id = var.public_hosted_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.ecs.dns_name
    zone_id                = aws_lb.ecs.zone_id
  }
}
