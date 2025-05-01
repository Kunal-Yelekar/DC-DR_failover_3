variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will launch"
  type        = string
}

variable "sg_ids" {
  description = "List of security group IDs for the instance"
  type        = list(string)
}

variable "instance_name" {
  description = "Name prefix for the instances"
  type        = string
}
