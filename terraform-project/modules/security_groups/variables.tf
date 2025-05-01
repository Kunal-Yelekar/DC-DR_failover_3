variable "vpc_id" {
  description = "VPC ID for the security groups"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "alb_ingress_port" {
  description = "Port on which ALB receives traffic"
  type        = number
}

variable "allowed_sources" {
  description = "List of allowed CIDR blocks for ALB ingress"
  type        = list(string)
}

variable "ec2_allowed_port" {
  description = "Port for traffic from ALB to EC2"
  type        = number
}

variable "admin_port" {
  description = "Administrative port"
  type        = number
}

variable "admin_ip_cidr" {
  description = "List of CIDR blocks allowed for admin access"
  type        = list(string)
}
