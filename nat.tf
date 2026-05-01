locals {
  nat_public_subnet_id = values(module.vpc.public_subnets)[0]
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "sre-nat-eip"
  }
}

resource "aws_nat_gateway" "app" {
  allocation_id = aws_eip.nat.id
  subnet_id     = local.nat_public_subnet_id

  tags = {
    Name = "sre-app-nat-gateway"
  }

  depends_on = [
    module.vpc
  ]
}

data "aws_route_tables" "private" {
  vpc_id = module.vpc.vpc_id

  filter {
    name   = "tag:Name"
    values = ["poc-private-*"]
  }

  depends_on = [
    module.vpc
  ]
}

resource "aws_route" "private_nat_gateway" {
  for_each = toset(data.aws_route_tables.private.ids)

  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app.id
}
