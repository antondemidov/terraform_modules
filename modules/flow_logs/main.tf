
#--------------------------------------------------------------
# This module creates flow logs bucket and enabling flow logs
#--------------------------------------------------------------

resource "aws_flow_log" "flow_logs" {
  count                = var.enable_flow_logs ? 1 : 0
  log_destination      = join("", aws_s3_bucket.log-bucket.*.arn)
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
}

resource "aws_s3_bucket" "log-bucket" {
  bucket = var.flow_logs_bucket
  count  = var.enable_flow_logs ? 1 : 0
  lifecycle_rule {
    id      = "log"
    enabled = true

    expiration {
      days = 90
    }
  }
}
