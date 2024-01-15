#defines variable for prefix 'ProjectF'
variable "prefix" {
  type    = string
  default = "ProjectF"
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


