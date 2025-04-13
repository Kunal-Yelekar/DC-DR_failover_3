variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security Group ID for ALB"
  type        = string
}

variable "target_group_port" {
  description = "Port for target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for target group"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID to attach to target group"
  type        = string
}

variable "waf_acl_arn" {
  description = "WAF ACL ARN to associate with ALB"
  type        = string
}
