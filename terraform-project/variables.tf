variable "backend_bucket" {
  description = "S3 bucket for storing Terraform remote state"
  type        = string
}

variable "backend_key" {
  description = "Path within the S3 bucket for the Terraform state"
  type        = string
}

variable "backend_region" {
  description = "AWS region for S3 bucket"
  type        = string
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table for state locking"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g. production, staging)"
  type        = string
}

variable "default_region" {
  description = "Default AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {
    Project = "AWS-DR-DC"
  }
}

# VPC CIDRs and Subnet definitions
variable "dc_vpc_cidr" {
  description = "CIDR block for DC VPC"
  type        = string
}

variable "dr_vpc_cidr" {
  description = "CIDR block for DR VPC"
  type        = string
}

variable "dc_public_subnets" {
  description = "List of public subnet CIDRs for DC VPC"
  type        = list(string)
}

variable "dr_public_subnets" {
  description = "List of public subnet CIDRs for DR VPC"
  type        = list(string)
}

variable "dc_private_subnets" {
  description = "List of private subnet CIDRs for DC VPC"
  type        = list(string)
}

variable "dr_private_subnets" {
  description = "List of private subnet CIDRs for DR VPC"
  type        = list(string)
}

variable "dc_azs" {
  description = "Availability zones for DC VPC"
  type        = list(string)
}

variable "dr_azs" {
  description = "Availability zones for DR VPC"
  type        = list(string)
}

# EC2 variables
variable "dc_instance_count" {
  description = "Number of EC2 instances in DC VPC"
  type        = number
}

variable "dr_instance_count" {
  description = "Number of EC2 instances in DR VPC"
  type        = number
}

variable "ami" {
  description = "AMI ID for EC2 instances (same for both environments)"
  type        = string
}

variable "dc_instance_type" {
  description = "EC2 instance type for DC VPC"
  type        = string
}

variable "dr_instance_type" {
  description = "EC2 instance type for DR VPC"
  type        = string
}

variable "dc_ec2_sg" {
  description = "Security Group ID for EC2 instances in DC VPC"
  type        = string
}

variable "dr_ec2_sg" {
  description = "Security Group ID for EC2 instances in DR VPC"
  type        = string
}

# ALB variables
variable "dc_alb_sg" {
  description = "Security Group ID for DC ALB"
  type        = string
}

variable "dr_alb_sg" {
  description = "Security Group ID for DR ALB"
  type        = string
}

variable "target_group_port" {
  description = "Port for the ALB target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for the ALB target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Path for the target group health check"
  type        = string
  default     = "/health"
}

variable "health_check_matcher" {
  description = "Matcher for the health check response"
  type        = string
  default     = "200"
}

variable "listener_port" {
  description = "Listener port for the ALB"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Listener protocol for the ALB"
  type        = string
  default     = "HTTP"
}

# Global Accelerator variables
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
