locals {
  management_subnet_id  = values(module.vpc.public_subnets)[0]
  application_subnet_id = values(module.vpc.private_subnets)[0]
}

resource "aws_instance" "management" {
  ami                         = data.aws_ami.rhel_9.id
  instance_type               = "t2.micro"
  subnet_id                   = local.management_subnet_id
  vpc_security_group_ids      = [aws_security_group.management.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "sre-management-ec2"
    Role = "management"
  }
}

resource "aws_launch_template" "app" {
  name_prefix   = "sre-app-"
  image_id      = data.aws_ami.rhel_9.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.app.id
  ]

  user_data = base64encode(file("${path.module}/user_data/apache.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "sre-app-web"
      Role = "application"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "sre-app-asg"
  min_size            = 2
  max_size            = 6
  desired_capacity    = 2
  vpc_zone_identifier = [local.application_subnet_id]

  health_check_type         = "ELB"
  health_check_grace_period = 600

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.app.arn
  ]

  tag {
    key                 = "Name"
    value               = "sre-app-web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Role"
    value               = "application"
    propagate_at_launch = true
  }
}
