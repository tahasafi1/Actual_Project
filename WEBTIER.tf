##copied

resource "aws_launch_configuration" "webtier" {
  #   name_prefix                 = var.prefix
  image_id                    = data.aws_ami.amazon-linux2.id
  instance_type               = "t2.micro"
  # key_name                    = var.key_name
  security_groups             = [module.security-groups.security_group_id["WEB_EC2_sg"]]
  associate_public_ip_address = true
  #user_data                   = templatefile("files/presentation_user_data.tmpl", {database_name = var.database_name})

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "webtier" {
  #   name_prefix = var.prefix
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
}

resource "aws_autoscaling_group" "webtier_asg" {
  #   name_prefix          = var.prefix
  launch_configuration = aws_launch_configuration.webtier.name
  min_size             = 2
  max_size             = 6
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_subnet.public_subnets["Public_Sub_WEB_1A"].id, aws_subnet.public_subnets["Public_Sub_WEB_1B"].id]
  target_group_arns    = [aws_lb_target_group.webtier.arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "webtier_asg_policy" {
  name                   = "webtier_asg_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.webtier_asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}

resource "aws_lb" "webtier_alb" {
  #   name_prefix        = var.prefix
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security-groups.security_group_id["ALB_WEB_sg"]]
  subnets            = [aws_subnet.public_subnets["Public_Sub_WEB_1A"].id, aws_subnet.public_subnets["Public_Sub_WEB_1B"].id]
}

resource "aws_lb_listener" "webtier_alb_listener_1" {
  load_balancer_arn = aws_lb.webtier_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}