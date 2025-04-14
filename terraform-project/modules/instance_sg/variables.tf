variable "vpc_id" {
  description = "VPC ID for the instance SG"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB Security Group ID to allow traffic from"
  type        = string
}
variable "name" {
  description = "Name of the instance security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the instance SG is deployed"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID of the ALB (as source for instance traffic)"
  type        = string
}
