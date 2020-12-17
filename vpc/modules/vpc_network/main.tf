#--------------------------------------------------------------
# This module creates all resources necessary for a VPC
#--------------------------------------------------------------

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.default_tags, map(
    "Name", "vpc-${var.group}-${var.env}",
    "env", var.env,
    "region", var.region,
  ))

  lifecycle {
    create_before_destroy = true
  }
}
