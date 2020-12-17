# This module creates all resources necessary for a private
# subnet
#--------------------------------------------------------------

resource "aws_subnet" "private" {
  vpc_id = var.vpc_id

  cidr_block = element(concat(var.private_subnets, [""]), count.index)

  availability_zone = element(split(",", var.azs), count.index)
  count             = length(split(",", var.azs))

  tags = merge(var.default_tags, map(
    "Name", "private-subnet-${var.env}-${var.group}-${element(concat(var.private_subnets, [""]), count.index)}",
    "env", var.env,
    "region", var.region,
    "layer", "private",
    "group", var.group
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  count  = length(split(",", var.azs))

  tags = merge(var.default_tags, map(
    "Name", "private-routetable-${var.env}-${var.group}-${element(concat(var.private_subnets, [""]), count.index)}",
    "env", var.env,
    "region", var.region
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "nat" {
  count                  = var.single_nat_gateway ? 1 : length(split(",", var.azs))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(split(",", var.nat_gateway_ids), count.index)
  depends_on             = [aws_route_table.private]
}

resource "aws_route_table_association" "private" {
  count     = length(split(",", var.azs))
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, var.single_nat_gateway ? 0 : count.index,
  )

  depends_on = [aws_route_table.private, aws_route.nat]
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.private.0.id
}
