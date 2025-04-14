variable "name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "scope" {
  description = "WAF scope: REGIONAL or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}

variable "default_action" {
  description = "Default action for the WAF ACL"
  type        = any
  default     = { allow = {} }
}

variable "visibility_config" {
  description = "Visibility configuration for the Web ACL"
  type        = any
  default     = {
    cloudwatch_metrics_enabled = true
    metric_name                = "wafMetric"
    sampled_requests_enabled   = true
  }
}
