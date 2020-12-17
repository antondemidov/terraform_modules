#--------------------------------------------------------------
# This module creates all resources necessary for a public
# subnet
#--------------------------------------------------------------

resource "aws_internet_gateway" "public" {
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, map(
    "Name", "igw-${var.env}-${var.group}",
    "env", var.env,
    "region", var.region
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "public" {
  vpc_id = var.vpc_id

  cidr_block = element(concat(var.public_subnets, [""]), count.index)

  availability_zone = element(split(",", var.azs), count.index)

  count = length(split(",", var.azs))

  tags = merge(var.default_tags, map(
    "Name", "public-subnet-${var.env}-${var.group}-${element(concat(var.public_subnets, [""]), count.index)}",
    "env", var.env,
    "region", var.region,
    "layer", "public",
    "group", var.group
  ))

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = merge(var.default_tags, map(
    "Name", "public-routetable-${var.env}-${var.group}",
    "env", var.env,
    "region", var.region
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.public.id
  depends_on             = [aws_route_table.public]
}

resource "aws_route_table_association" "public" {
  count          = length(split(",", var.azs))
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
