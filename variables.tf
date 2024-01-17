#defines variable for prefix 'ProjectF'
variable "prefix" {
  type    = string
  default = "FinalProject"
}

#defines map of objects for public subnets going to be used w/ for_each
variable "public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  default = {
  }
}

#defines map of objects for private subnets going to be used w/ for_each
variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))

  default = {
  }
}

#virtual firewall
variable "security-groups" {
  description = "A map of security groups with their rules"
  type = map(object({
    description = string
    ingress_rules = optional(list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    })))
    egress_rules = list(object({
      description = optional(string)
      priority    = optional(number)
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
  default = {}
}

variable "private-nat-routetable-assoc" {
  type = map(object({
    route_table_id = string
    subnet_id      = string
  }))
  default = {
  }
}

#defines instances for EC2 being used w/ for each
variable "ec2-instance" {
  type = map(object({
    server_name = string,
    subnet_id   = string
  }))
  default = {
  }
}

variable "myip" {
  type = string
  default = "70.190.92.126"
}





# variable "max_password_age" {
#   type        = number
#   default     = 90
#   description = "The number of days that an user password is valid."
# }

# variable "password_reuse_prevention" {
#   type        = number
#   default     = 3
#   description = "The number of previous passwords that users are prevented from reusing."
# }

# variable "hard_expiry" {
#   type        = string
#   default     = false
#   description = "Whether users are prevented from setting a new password after their password"
# }

# # variable "vpc_id" {
# #   type    = string
# #   default = "vpc"
# # }
# # locals {
# #   ALB_WEB_sg_name  = "ALB_WEB_sg"
# #   ALB_APP_sg_name  = "ALB_APP_sg"
# #   WEB_EC2_sg_name  = "WEB_EC2_sg"
# #   APP_EC2_sg_name  = "APP_EC2_sg"
# #   database_sg_name = "database_sg"
# #   bastion_sg_name  = "bastion_sg"
# # }


# variable "iam_user" {
#   type = map(object({
#     name = string,
#     tags = map(string)
#   }))
#   default = {

#   }
# }
# variable "known_hosts" {
#   type    = string
#   default = "0.0.0.0/0"
# }