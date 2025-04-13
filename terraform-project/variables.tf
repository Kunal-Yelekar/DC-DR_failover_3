variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "backend_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
}

variable "backend_key" {
  description = "Terraform state file key"
  type        = string
}

variable "backend_region" {
  description = "Region where backend S3 bucket is located"
  type        = string
  default     = "ap-south-1"
}

variable "backend_lock_table" {
  description = "DynamoDB table for state locking"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDRs for public subnets. In this design, we assume two public subnets, one for each AZ."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "List of CIDRs for private subnets. In this design, one private subnet per AZ."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "alb_allowed_ports" {
  description = "Ports allowed for ALB Security Group"
  type        = list(number)
  default     = [80, 443, 22]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "EC2 AMI ID – make sure to use one available in ap-south-1"
  type        = string
  default     = "ami-0123456789abcdef0"  # Replace with a current AMI ID in ap-south-1
}

variable "waf_name" {
  description = "Name for the WAF Web ACL"
  type        = string
  default     = "my-waf"
}

variable "waf_scope" {
  description = "Scope for WAF, either REGIONAL or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}

variable "waf_default_action" {
  description = "Default action for the WAF"
  type        = string
  default     = "ALLOW"
}

variable "target_group_port" {
  description = "Port for the ALB target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the ALB target group"
  type        = string
  default     = "HTTP"
}
