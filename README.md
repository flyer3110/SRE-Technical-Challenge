### ALB Design Decision

The challenge requires three subnets: Management, Application, and Backend. Management is public, while Application and Backend are private. Because AWS Application Load Balancers require at least two subnets in different Availability Zones, this implementation places the ALB as an internal load balancer across the private Application and Backend subnets.

This keeps Application and Backend resources from being directly internet-accessible. In a production internet-facing design, I would add a second public subnet in another Availability Zone and place the public ALB across both public subnets, while keeping application EC2 instances private.

The current ASG uses a single application subnet. A production improvement would be to add a second private application subnet in another AZ and spread the ASG across both for better availability.