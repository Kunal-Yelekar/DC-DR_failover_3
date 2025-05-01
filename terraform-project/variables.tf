variable "aws_region" {
  description = "AWS region where the resources will be deployed"
  type        = string
  default     = "ap-south-1"
}

variable "dc_vpc_cidr" {
  description = "CIDR block for DC VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dr_vpc_cidr" {
  description = "CIDR block for DR VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "dc_public_subnet_cidrs" {
  description = "Public subnet CIDRs for DC VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "dr_public_subnet_cidrs" {
  description = "Public subnet CIDRs for DR VPC"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0abcdef1234567890"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "admin_ips" {
  description = "IP addresses allowed SSH access to EC2 instances"
  type        = list(string)
  default     = ["10.0.0.0/16"]  # Change to your trusted IP ranges
}

variable "backend_bucket" {
  description = "S3 bucket name used for remote backend storage"
  type        = string
}

variable "backend_region" {
  description = "AWS region for the S3 backend"
  type        = string
  default     = var.aws_region
}

variable "dynamodb_table" {
  description = "DynamoDB table for state locking"
  type        = string
}
