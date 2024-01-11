# ## instances

# resource "aws_db_instance" "dbinstance" {
#   allocated_storage      = 10
#   db_name                = "dbinstance"
#   engine                 = "mysql"
#   engine_version         = "5.7"
#   instance_class         = "db.t2.micro"
#   username               = "rdsinstanceusername"
#   password               = "rdsinstancepassword"
#   parameter_group_name   = "default.mysql5.7"
#   skip_final_snapshot    = true
#   vpc_security_group_ids = [module.security-groups.security_group_id["database_sg"]]
# }    