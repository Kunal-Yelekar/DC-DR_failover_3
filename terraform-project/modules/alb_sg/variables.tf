variable "name" {
  description = "Security group name for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID in which to create the ALB security group"
  type        = string
}
