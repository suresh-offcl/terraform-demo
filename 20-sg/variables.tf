variable "project_name" {
  default = "expense"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project= "expense"
    Environment= "dev"
    Terraform = true
  }
}


variable "vpn_sg_tags" {
  default = {
    Component = "vpn"
    Project= "expense"
    Environment= "dev"
    Terraform = true
  }
}

variable "mysql_sg_tags" {
  default = {
    component = "mysql"
    Project= "expense"
    Environment= "dev"
    Terraform = true
  }
}

variable "backend_sg_tags" {
 default = {
    component = "backend"
    Project= "expense"
    Environment= "dev"
    Terraform = true
  }
}
variable "frontend_sg_tags" {
  default = {
    component = "frontend"
    Project= "expense"
    Environment= "dev"
    Terraform = true
  }
}
variable "bastion_sg_tags" {
  default = {
    component = "bastion"
    Project= "expense"
    Environment= "dev"
    Terraform = true
  }
}
variable "ansible_sg_tags" {
  default = {
    component = "ansible"
    Project= "expense"
    Environment= "dev"
    Terraform = true
  }
}
variable "app_alb_sg_tags" {
  default = {
    component = "app-alb"
    Project= "expense"
    Environment= "dev"
    Terraform = true
  }
}