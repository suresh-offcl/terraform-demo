module "app_alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = true
  name    = "${local.resource_name}-app-alb"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids

  security_groups = [local.app_alb_sg_id]
  create_security_group = false
   enable_deletion_protection = false 
  tags = merge(
    var.common_tags,
    var.app_alb_tags,
    
  )

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from Application alb</h1>"
      status_code  = "200"
    }
  }
  
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "*.app-${var.environment}"
      type    = "A"
      alias   = {
        name    = module.app_alb.dns_name
        zone_id = module.app_alb.zone_id
    }
    allow_overwrite = true
    }
  ]

  
}