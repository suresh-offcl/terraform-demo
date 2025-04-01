module "mysql_sg" {
  source = "git::https://github.com/suresh-offcl/terraform-aws-securitygroup1.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  vpc_id = local.vpc_id
  sg_name = "mysql"
  common_tags=var.mysql_sg_tags 
    

}

module "backend_sg" {
  source = "git::https://github.com/suresh-offcl/terraform-aws-securitygroup1.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  vpc_id = local.vpc_id
  sg_name = "backend"
  common_tags=var.backend_sg_tags 

}



module "frontend_sg" {
  source = "git::https://github.com/suresh-offcl/terraform-aws-securitygroup1.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  vpc_id = local.vpc_id
  sg_name = "frontend"
  common_tags=var.frontend_sg_tags 

}

module "bastion_sg" {
  source = "git::https://github.com/suresh-offcl/terraform-aws-securitygroup1.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  vpc_id = local.vpc_id
  sg_name = "bastion"
  common_tags=var.backend_sg_tags 

}

module "ansible_sg" {
  source = "git::https://github.com/suresh-offcl/terraform-aws-securitygroup1.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  vpc_id = local.vpc_id
  sg_name = "ansible"
  common_tags=var.ansible_sg_tags 

}

module "vpn_sg" {
  source = "git::https://github.com/suresh-offcl/terraform-aws-securitygroup1.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  vpc_id = local.vpc_id
  sg_name = "ansible"
  common_tags=var.vpn_sg_tags 

}

module "app_alb_sg" {
  source = "git::https://github.com/suresh-offcl/terraform-aws-securitygroup1.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  vpc_id = local.vpc_id
  sg_name = "app-alb"
  common_tags=var.app_alb_sg_tags 

}


 resource "aws_security_group_rule" "mysql_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.id
  security_group_id = module.mysql_sg.id
}
 

/* resource "aws_security_group_rule" "backend_frontend" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.id
  security_group_id = module.backend_sg.id
}

resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend_sg.id
} */

resource "aws_security_group_rule" "mysql_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.mysql_sg.id
  security_group_id = module.bastion_sg.id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.backend_sg.id
  security_group_id = module.bastion_sg.id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.frontend_sg.id
  security_group_id = module.bastion_sg.id
}

/* resource "aws_security_group_rule" "mysql_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.mysql_sg.id
  security_group_id = module.ansible_sg.id
} */


resource "aws_security_group_rule" "backend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id = module.backend_sg.id
}

resource "aws_security_group_rule" "frontend_ansible" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.ansible_sg.id
  security_group_id = module.frontend_sg.id
}

resource "aws_security_group_rule" "ansible_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.ansible_sg.id
}
 
resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.backend_sg.id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.backend_sg.id
  source_security_group_id = module.app_alb_sg.id
}

resource "aws_security_group_rule" "app_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.app_alb_sg.id
  source_security_group_id = module.bastion_sg.id
}

/* resource "aws_security_group_rule" "vpn_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}
 */
resource "aws_security_group_rule" "vpn_public_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}

resource "aws_security_group_rule" "vpn_public_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}

resource "aws_security_group_rule" "vpn_public_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.vpn_sg.id
}

resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = module.app_alb_sg.id
  source_security_group_id = module.vpn_sg.id
}

/* resource "aws_security_group_rule" "backend_vpn" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = module.backend_sg.id
  source_security_group_id = module.vpn_sg.id
}
 */
resource "aws_security_group_rule" "backend_vpn_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  security_group_id = module.backend_sg.id
  source_security_group_id = module.vpn_sg.id
}