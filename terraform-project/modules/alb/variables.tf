variable "name" {
  description = "Name for the ALB"
  type        = string
}

variable "subnets" {
  description = "Subnets in which the ALB will be deployed"
  type        = list(string)
}

variable "sg_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "load_balancer_type" {
  description = "The type of the load balancer (e.g., application)"
  type        = string
  default     = "application"
}

variable "ip_address_type" {
  description = "IP address type (ipv4 or dualstack)"
  type        = string
  default     = "ipv4"
}
