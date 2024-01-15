#public subnets
public_subnets = {
  public_sub_web_1 = {
    cidr_block        = "172.16.0.0/24"
    availability_zone = "us-west-2a"
  }
  public_sub_web_2 = {
    cidr_block        = "172.16.1.0/24"
    availability_zone = "us-west-2b"
  }
}

private_subnets = {
  private_sub_app_1 = {
    cidr_block        = "172.16.2.0/24"
    availability_zone = "us-west-2a"
  },
  privat_sub_app_2 = {
    cidr_block        = "172.16.3.0/24"
    availability_zone = "us-west-2b"
  },
  private_sub_database_1 = {
    cidr_block        = "172.16.4.0/24"
    availability_zone = "us-west-2a"
  },
  private_sub_database_2 = {
    cidr_block        = "172.16.5.0/24"
    availability_zone = "us-west-2b"
  }
}


#nat route table association
private-nat-routetable-assoc = {
  apptier1assoc = {
    route_table_id = "public_sub_web_1"
    subnet_id      = "private_sub_app_1"
  }
  apptier2assoc = {
    route_table_id = "public_sub_web_2"
    subnet_id      = "privat_sub_app_2"
  }
  databasetier1assoc = {
    route_table_id = "public_sub_web_1"
    subnet_id      = "private_sub_database_1"
  }
  databasetier2assoc = {
    route_table_id = "public_sub_web_2"
    subnet_id      = "private_sub_database_2"
  }
}

# security-groups = {
#   "alb_web_sg" : {
#     description = "Security group for web servers"
#     ingress_rules = [
#       {
#         description = "ingress rule for http"
#         priority    = 200
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "ingress rule for http"
#         priority    = 204
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#     egress_rules = [
#       {
#         description = "egress rule"
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   },
#   "WEB_EC2_sg" : {
#     description = "Security group for web servers"
#     ingress_rules = [
#       {
#         description = "ingress rule for http"
#         priority    = 200
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "my_ssh"
#         priority    = 202
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       },
#       {
#         description = "ingress rule for http"
#         priority    = 204
#         from_port   = 443
#         to_port     = 443
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#     egress_rules = [
#       {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   },
#   "ALB_APP_sg" : {
#     description = "Security group for web servers"
#     ingress_rules = [
#       {
#         description = "ingress rule for http"
#         priority    = 200
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         #security_groups = [var.security-groups.security_groups["ALB_WEB_sg"]]
#       }
#     ]
#     egress_rules = [
#       {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   },
#   "APP_EC2_sg" : {
#     description = "Security group for web servers"
#     ingress_rules = [
#       {
#         description = "ingress rule for http"
#         priority    = 200
#         from_port   = 80
#         to_port     = 80
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         #security_groups = [module.security-groups.security_group_id["ALB_APP_sg"]]
#       },
#       {
#         description = "my_ssh"
#         priority    = 202
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#     egress_rules = [
#       {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   },
#   "DB_sg" : {
#     description = "Security group for Database"
#     ingress_rules = [
#       {
#         description = "ingress rule for DB"
#         priority    = 500
#         from_port   = 3306
#         to_port     = 3306
#         protocol    = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#         #security_groups = [module.security-groups["ALB_WEB_sg"].id]
#       }
#     ]
#     egress_rules = [
#       {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     ]
#   }
# }

