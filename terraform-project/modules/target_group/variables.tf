variable "name" {
  description = "Name for the target group"
  type        = string
}

variable "port" {
  description = "Port for the target group"
  type        = number
}

variable "protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "vpc_id" {
  description = "VPC ID in which the target group is created"
  type        = string
}

variable "health_check_path" {
  description = "HTTP path for health checks"
  type        = string
}
