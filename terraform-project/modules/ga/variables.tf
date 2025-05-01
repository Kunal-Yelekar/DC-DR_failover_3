variable "environment" {
  description = "Environment name for Global Accelerator"
  type        = string
}

variable "region" {
  description = "Region for endpoint group"
  type        = string
}

variable "dc_alb_arn" {
  description = "ARN of the DC ALB"
  type        = string
}

variable "dr_alb_arn" {
  description = "ARN of the DR ALB"
  type        = string
}

variable "ga_listener_port" {
  description = "Listener port for Global Accelerator"
  type        = number
  default     = 80
}

variable "ga_listener_protocol" {
  description = "Listener protocol for Global Accelerator"
  type        = string
  default     = "TCP"
}

variable "ga_health_check_port" {
  description = "Health check port for Global Accelerator"
  type        = number
  default     = 80
}

variable "ga_health_check_protocol" {
  description = "Health check protocol for Global Accelerator"
  type        = string
  default     = "HTTP"
}
