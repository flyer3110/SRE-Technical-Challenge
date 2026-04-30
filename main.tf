data "aws_availability_zones" "available" {
  filter {
    name   = "state"
    values = ["available"]
  }

}

data "aws_ami" "rhel_9" {
  most_recent = true
  owners      = ["309956199498"]

  filter {
    name   = "name"
    values = ["RHEL-9.*_HVM-*-x86_64-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "git::https://github.com/Coalfire-CF/terraform-aws-vpc-nfw.git?ref=main"

  vpc_name        = "poc-vpc"
  resource_prefix = "poc"
  cidr            = "10.1.0.0/16"

  azs = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]

  subnets = [
    {
      tag               = "management"
      cidr              = "10.1.1.0/24"
      type              = "public"
      availability_zone = data.aws_availability_zones.available.names[0]
    },
    {
      tag               = "application"
      cidr              = "10.1.2.0/24"
      type              = "private"
      availability_zone = data.aws_availability_zones.available.names[0]
    },
    {
      tag               = "backend"
      cidr              = "10.1.3.0/24"
      type              = "private"
      availability_zone = data.aws_availability_zones.available.names[1]
    }

  ]

  deploy_aws_nfw            = false
  flow_log_destination_type = "cloud-watch-logs"
}
