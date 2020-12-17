variable "env" {
  description = "environment"
  type        = string
  default     = "dev"
}
variable "vpc_id" {
  description = "VPC id form vpc module"
  type        = string
  default     = ""
}

variable "flow_logs_bucket" {
  description = "Name of S3 bucket for flow logs"
  type        = string
  default     = ""
}
variable "enable_flow_logs" {
  description = "Should be true if you want to enable VPC flow logs"
  type        = bool
  default     = false
}
