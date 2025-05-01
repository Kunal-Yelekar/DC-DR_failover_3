variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "ami" {
  description = "AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets in which to deploy EC2 instances"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for the EC2 instance"
  type        = list(string)
}

variable "environment" {
  description = "Environment name, e.g., DC or DR"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
