variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-2"
}

variable "dc_vpc_cidr" {
  description = "CIDR block for the DC VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dr_vpc_cidr" {
  description = "CIDR block for the DR VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dc_azs" {
  description = "Availability zones for DC VPC subnets"
  type        = list(string)
  default     = ["ap-south-2a"]
}

variable "dr_azs" {
  description = "Availability zones for DR VPC subnets"
  type        = list(string)
  default     = ["ap-south-2b"]
}

variable "failover" {
  description = "Toggle to manually switch traffic (true = DR active, false = normal: 100% DC)"
  type        = bool
  default     = false
}

variable "ami" {
  description = "AMI ID to use for EC2 instances"
  type        = string
  default     = "ami-0abcdef1234567890"  # Change to a valid AMI in ap-south-2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
