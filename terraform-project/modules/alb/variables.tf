variable "alb_name" {
  description = "Name for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID in which to deploy the ALB"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "sg_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "alb_target_group_name" {
  description = "Name for the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for target group (HTTP/HTTPS)"
  type        = string
}

variable "listener_port" {
  description = "ALB listener port"
  type        = number
}

variable "listener_protocol" {
  description = "ALB listener protocol (HTTP/HTTPS)"
  type        = string
}

variable "health_check_healthy_threshold" {
  description = "Healthy threshold for ALB health check"
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "Unhealthy threshold for ALB health check"
  type        = number
}

variable "health_check_timeout" {
  description = "Timeout (in seconds) for ALB health check"
  type        = number
}

variable "health_check_interval" {
  description = "Interval (in seconds) for ALB health check"
  type        = number
}

variable "health_check_path" {
  description = "URL path for ALB health check"
  type        = string
}

variable "health_check_matcher" {
  description = "Matcher for ALB health check (e.g. 200-299)"
  type        = string
  default     = "200-299"
}

variable "waf_name" {
  description = "Name for the WAF"
  type        = string
}
