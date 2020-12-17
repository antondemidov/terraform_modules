variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = string
  default     = "us-east-1a,us-east-1b,us-east-1c"
}
variable "public_subnet_ids" {
  description = "A list of public subnets generated by public_subnet module"
}

variable "public_subnets_by_az" {
  type        = map(string)
  description = "A map of public subnets by AZ generated by public_subnet module"
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
variable "default_tags" {
  description = "Defaul Tags"
  type        = map(string)
  default     = {}
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}
