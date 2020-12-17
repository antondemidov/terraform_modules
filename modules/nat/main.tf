#--------------------------------------------------------------
# This module creates all resources necessary for NAT
#--------------------------------------------------------------

resource "aws_eip" "nat" {
  vpc = true

  count = var.single_nat_gateway ? 1 : length(split(",", var.azs))

  tags = merge(var.default_tags, map(
    "Name", "eip-vpc-${var.group}-${var.env}",
    "env", var.env,
    "region", var.region
  ))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = lookup(var.public_subnets_by_az, element(split(",", var.azs), count.index))

  count = var.single_nat_gateway ? 1 : length(split(",", var.azs))

  tags = merge(var.default_tags, map(
    "Name", "nat_gw-vpc-${var.group}-${var.env}",
    "env", var.env,
    "region", var.region
  ))

  lifecycle {
    create_before_destroy = true
  }
}
