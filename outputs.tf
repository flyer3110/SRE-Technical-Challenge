output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "management_public_ip" {
  description = "Public IP of the management EC2 instance"
  value       = aws_instance.management.public_ip
}

output "application_asg_name" {
  description = "Name of the application Auto Scaling Group"
  value       = aws_autoscaling_group.app.name
}
