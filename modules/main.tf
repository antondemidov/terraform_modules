#--------------------------------------------------------------
# This module creates all networking resources
#--------------------------------------------------------------
variable "vpc_cidr" {
  description = "VPC cidr"
  type        = string
  default     = ""
}
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = string
  default     = "us-east-1a,us-east-1b,us-east-1c"
}
variable "env" {
  description = "environment"
  type        = string
  default     = "dev"
}
variable "group" {
  description = "purpose or group who is using"
  type        = string
  default     = ""
}
variable "region" {
  description = "aws regions"
  type        = string
  default     = "us-east-1"
}
variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}
variable "enable_flow_logs" {
  description = "Should be true if you want to enable VPC flow logs"
  type        = bool
  default     = false
}
variable "flow_logs_bucket" {
  description = "Name of S3 bucket for flow logs"
  type        = string
  default     = ""
}

variable "default_tags" {
  description = "Defaul Tags"
  type        = map(string)
  default     = {}
}

module "vpc" {
  source = "./vpc_network"

  cidr  = var.vpc_cidr
  group = var.group

  region       = var.region
  env          = var.env
  default_tags = var.default_tags
}

module "public_subnet" {
  source         = "./public_subnet"
  vpc_id         = module.vpc.vpc_id
  public_subnets = var.public_subnets
  cidr           = var.vpc_cidr
  azs            = var.azs
  env            = var.env
  group          = var.group
  region         = var.region
  default_tags   = var.default_tags
}

module "nat" {
  source               = "./nat"
  azs                  = var.azs
  env                  = var.env
  group                = var.group
  region               = var.region
  default_tags         = var.default_tags
  single_nat_gateway   = var.single_nat_gateway
  public_subnet_ids    = module.public_subnet.subnet_ids
  public_subnets_by_az = module.public_subnet.subnet_by_azs
}

module "private_subnet" {
  source             = "./private_subnet"
  vpc_id             = module.vpc.vpc_id
  cidr               = var.vpc_cidr
  azs                = var.azs
  env                = var.env
  group              = var.group
  region             = var.region
  default_tags       = var.default_tags
  private_subnets    = var.private_subnets
  single_nat_gateway = var.single_nat_gateway
  nat_gateway_ids    = module.nat.nat_gateway_ids
}

module "flow_logs" {
  source = "./flow_logs"

  vpc_id           = module.vpc.vpc_id
  env              = var.env
  flow_logs_bucket = var.flow_logs_bucket
  enable_flow_logs = var.enable_flow_logs
}
# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

# Subnets
output "public_subnet_ids" {
  value = module.public_subnet.subnet_ids
}

output "private_subnet_ids" {
  value = module.private_subnet.subnet_ids
}

# NAT
output "nat_gateway_ids" {
  value = module.nat.nat_gateway_ids
}
