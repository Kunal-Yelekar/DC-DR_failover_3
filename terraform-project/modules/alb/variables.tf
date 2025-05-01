variable "environment" {
  description = "Environment name, e.g., DC or DR"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for ALB deployment"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups for ALB"
  type        = list(string)
}

variable "target_group_port" {
  description = "Port for target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/"
}

variable "health_check_matcher" {
  description = "Matcher for health check"
  type        = string
  default     = "200"
}

variable "listener_port" {
  description = "Listener port for ALB"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Listener protocol for ALB"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "VPC ID for target group"
  type        = string
}

variable "tags" {
  description = "Tags applied to ALB and target group"
  type        = map(string)
  default     = {}
}
