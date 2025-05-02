variable "accelerator_name" {
  description = "Name for the Global Accelerator"
  type        = string
}

variable "endpoint_alb_dc" {
  description = "ARN of the DC ALB (used as an endpoint)"
  type        = string
}

variable "endpoint_alb_dr" {
  description = "ARN of the DR ALB (used as an endpoint)"
  type        = string
}

variable "health_check_interval" {
  description = "Health check interval (in seconds) for Global Accelerator"
  type        = number
}

variable "endpoint_threshold_count" {
  description = "Threshold count for Global Accelerator health checks"
  type        = number
}

variable "global_accelerator_listener_port" {
  description = "Listener port for Global Accelerator"
  type        = number
}

variable "global_accelerator_protocol" {
  description = "Listener protocol for Global Accelerator (e.g. TCP)"
  type        = string
}

variable "dc_weight" {
  description = "Weight for the DC ALB endpoint. Set to 128 to be active, 0 to put in standby."
  type        = number
  default     = 128
}

variable "dr_weight" {
  description = "Weight for the DR ALB endpoint. Set to 128 to be active, 0 to put in standby."
  type        = number
  default     = 128
}
