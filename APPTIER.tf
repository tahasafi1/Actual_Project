# resource "aws_launch_configuration" "apptier" {
#   # name_prefix     = var.prefix
#   image_id        = data.aws_ami.amazon-linux2.id
#   instance_type   = "t2.micro"
#   #key_name        = aws_key_pair.apptier.key_name
#   security_groups = [module.app_security_group.security_group_id["app_sg"]]
#   # user_data       = templatefile("files/application_docker_user_data.tmpl", {app_repo = var.app_repo, app_name = var.app_name, database_name = var.database_name})
#   user_data = <<-EOF
#             #!/bin/bash
#            {

#             # Update the system
#             sudo dnf -y update
#             # Install MySQL Community Server
#             sudo dnf -y install https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
#             sudo dnf -y install mysql-community-server
#             # Start and enable MySQL
#             sudo systemctl start mysqld
#             sudo systemctl enable mysqld
#             # Install Apache and PHP
#             sudo dnf -y install httpd php
#             # Start and enable Apache
#             sudo systemctl start httpd
#             sudo systemctl enable httpd
#             cd /var/www/html
#             sudo wget https://aws-tc-largeobjects.s3-us-west-2.amazonaws.com/CUR-TF-200-ACACAD/studentdownload/lab-app.tgz
#             sudo tar xvfz lab-app.tgz
#             sudo chown apache:root /var/www/html/rds.conf.php
#             } &> /var/log/user_data.log               
#             EOF            
#   lifecycle {
#     create_before_destroy = true
#   }
# }
# # resource "aws_key_pair" "apptier" {
# #   key_name   = "apptier-key"
# #   public_key = file("~/.ssh/cloud2024.pem.pub")
# # }

# resource "aws_lb_target_group" "apptier_tg" {
#   # name_prefix = var.prefix
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id
# }

# resource "aws_autoscaling_group" "apptier_asg" {
#   name_prefix          = "app-"
#   launch_configuration = aws_launch_configuration.apptier.name
#   min_size             = 2
#   max_size             = 6
#   health_check_type    = "ELB"
#   vpc_zone_identifier  = [aws_subnet.private_subnets["Private_Sub_APP_1B"].id, aws_subnet.private_subnets["Private_Sub_APP_1A"].id]
#   target_group_arns    = [aws_lb_target_group.apptier_tg.arn]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_policy" "apptier_asg_policy" {
#   name                   = "application_asg_policy"
#   policy_type            = "TargetTrackingScaling"
#   autoscaling_group_name = aws_autoscaling_group.apptier_asg.name

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }

#     target_value = 70.0
#   }
# }

# resource "aws_lb" "apptier_alb" {
#   name_prefix        = "app-"
#   internal           = true
#   load_balancer_type = "application"
#   idle_timeout       = 65
#   security_groups    = [module.alb_app_security_group.security_group_id["alb_app_sg"]]
#   subnets            = [aws_subnet.private_subnets["Private_Sub_APP_1B"].id, aws_subnet.private_subnets["Private_Sub_APP_1A"].id]
# }
# resource "aws_lb_listener" "application_alb_listener_1" {
#   load_balancer_arn = aws_lb.apptier_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.apptier_tg.arn
#   }
# }


# output "application_alb" {
#   value = aws_lb.apptier_alb.dns_name
# }


# data "aws_ami" "amazon-linux2" {
#   owners      = ["amazon"]
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["al2023-ami-2023.*-x86_64"]
#   }
# }