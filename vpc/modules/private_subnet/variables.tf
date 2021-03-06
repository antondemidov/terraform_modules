variable "vpc_id" {
  description = "VPC id generated by vpc module"
  type        = string
  default     = "false"
}
variable "cidr" {
  description = "VPC cidr"
  type        = string
  default     = ""
}
variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = string
  default     = "us-east-1a,us-east-1b,us-east-1c"
}
variable "nat_gateway_ids" {
  description = "NAT GW Ids generated by nat module"
  type        = string
  default     = ""
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
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = string
  default     = "false"
}
variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "default_tags" {
  description = "Defaul Tags"
  type        = map(string)
  default     = {}
}
