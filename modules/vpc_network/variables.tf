variable "cidr" {
  description = "VPC cidr"
  type        = string
  default     = ""
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
variable "env" {
  description = "environment"
  type        = string
  default     = "dev"
}

variable "default_tags" {
  description = "Defaul Tags"
  type        = map(string)
  default     = {}
}
