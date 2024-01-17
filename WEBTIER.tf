# resource "aws_launch_configuration" "webtier" {
#   #   name_prefix                 = var.prefix
#   image_id                    = data.aws_ami.amazon-linux2.id
#   instance_type               = "t2.micro"
#   #key_name                    = aws_key_pair.webtier.key_name
#   security_groups             = [module.web_security_group.security_group_id["web_sg"]]
#   associate_public_ip_address = true
#   #user_data                   = templatefile("files/presentation_user_data.tmpl", {database_name = var.database_name})
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
# # resource "aws_key_pair" "webtier" {
# #   key_name   = "webtier-key"
# #   public_key = file("~/.ssh/cloud2024.pem.pub")
# # }

# resource "aws_lb_target_group" "webtier" {
#   #   name_prefix = var.prefix
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id
# }

# resource "aws_autoscaling_group" "webtier_asg" {
#   #   name_prefix          = var.prefix
#   launch_configuration = aws_launch_configuration.webtier.name
#   min_size             = 2
#   max_size             = 6
#   health_check_type    = "ELB"
#   vpc_zone_identifier  = [aws_subnet.public_subnets["Public_Sub_WEB_1A"].id, aws_subnet.public_subnets["Public_Sub_WEB_1B"].id]
#   target_group_arns    = [aws_lb_target_group.webtier.arn]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_policy" "webtier_asg_policy" {
#   name                   = "webtier_asg_policy"
#   policy_type            = "TargetTrackingScaling"
#   autoscaling_group_name = aws_autoscaling_group.webtier_asg.name

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }

#     target_value = 70.0
#   }
# }

# resource "aws_lb" "webtier_alb" {
#   #   name_prefix        = var.prefix
#   internal           = false
#   load_balancer_type = "application"
#   idle_timeout       = 65
#   security_groups    = [module.alb_web_security_group.security_group_id["alb_web_sg"]]
#   subnets            = [aws_subnet.public_subnets["Public_Sub_WEB_1A"].id, aws_subnet.public_subnets["Public_Sub_WEB_1B"].id]
# }

# resource "aws_lb_listener" "webtier_alb_listener_1" {
#   load_balancer_arn = aws_lb.webtier_alb.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.webtier.arn
#   }
# }
# #     type = "redirect"
# #     target_group_arn = aws_lb_target_group.webtier.arn
# #     redirect {
# #       port        = "443"
# #       protocol    = "HTTPS"
# #       status_code = "HTTP_301"
# #     }
# #   }
# # }

# # resource "aws_lb_listener" "webtier_alb_listener_2" {
# #   load_balancer_arn = aws_lb.webtier_alb.arn
# #   port              = "443"
# #   protocol          = "HTTPS"
# #   certificate_arn   = var.ssl_certificate_arn

# #   default_action {
# #     type             = "forward"
# #     target_group_arn = aws_lb_target_group.webtier.arn
# #   }
# # }


# output "webtier_alb" {
#   value = aws_lb.webtier_alb.dns_name
# }