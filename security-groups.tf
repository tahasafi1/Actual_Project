module "bastion_security_group" {
  source  = "./modules/security-groups"
  vpc_id  = aws_vpc.vpc.id
  security_groups = {
    "bastion_sg" : {
      description = "ALB SG"
      ingress_rules = [
        {
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [var.myip]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

module "web_security_group" {
  source  = "./modules/security-groups"
  vpc_id  = aws_vpc.vpc.id
  security_groups = {
    "web_sg" : {
      description = "Web Tier SG"
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [module.bastion_security_group_security_group.security_group_id["bastion_sg"]]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}

module "app_security_group" {
  source  = "./modules/security-groups"
  vpc_id  = aws_vpc.vpc.id
  security_groups = {
    "app_sg" : {
      description = "App Tier SG"
      ingress_rules = [
        {
          from_port   = 8080
          to_port     = 8080
          protocol    = "tcp"
          cidr_blocks = [module.web_security_group.security_group_id["web_sg"]]
        },
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = [module.bastion_security_group.security_group_id["bastion_sg"]]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
      "app_elb_sg" : {
        description = "App Load Balancer SG"
        ingress_rules = [
          {
            from_port   = 8080
            to_port     = 8080
            protocol    = "tcp"
            cidr_blocks = [module.web_security_group.security_group_id["web_sg"]]
          }
        ]
        egress_rules = [
          {
            from_port   = 0
            to_port     = 0
            protocol    = "-1"
            cidr_blocks = ["0.0.0.0/0"]
          }
        ]
      }
    }
  }
}

module "db_security_group" {
  source  = "./modules/security-groups"
  vpc_id  = aws_vpc.vpc.id
  security_groups = {
    "db_sg" : {
      description = "Database Tier SG"
      ingress_rules = [
        {
          from_port   = 3306
          to_port     = 3306
          protocol    = "tcp"
          cidr_blocks = [module.app_security_group.security_group_id["app_sg"]]
        }
      ]
      egress_rules = [
        {
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      ]
    }
  }
}   