locals {
  nat_public_subnet_id = values(module.vpc.public_subnets)[0]

  private_route_table_ids = {
    application = module.vpc.private_route_table_ids[0]
    backend     = module.vpc.private_route_table_ids[1]
  }
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

resource "aws_route" "private_nat_gateway" {
  for_each = local.private_route_table_ids

  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.app.id
}