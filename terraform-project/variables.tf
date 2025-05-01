variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "state_bucket" {
  description = "S3 Bucket for Terraform remote state"
  type        = string
}

variable "dynamodb_lock_table" {
  description = "DynamoDB Table for Terraform state locking"
  type        = string
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# VPC settings for DC and DR
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

variable "dc_public_subnets" {
  description = "Public subnet CIDRs for DC VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "dr_public_subnets" {
  description = "Public subnet CIDRs for DR VPC"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "dc_private_subnets" {
  description = "Private subnet CIDRs for DC VPC (if needed)"
  type        = list(string)
  default     = []
}

variable "dr_private_subnets" {
  description = "Private subnet CIDRs for DR VPC (if needed)"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "Availability Zones in the region"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "admin_cidrs" {
  description = "CIDR blocks for trusted administrative access"
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

# EC2 instance settings
variable "ec2_ami" {
  description = "AMI for the EC2 instances"
  type        = string
  default     = "ami-0abcdef1234567890"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "my-key"
}
