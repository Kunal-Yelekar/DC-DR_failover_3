variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "ami" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID within which the instance is launched"
  type        = string
}

variable "sg_ids" {
  description = "List of security groups for the instance"
  type        = list(string)
}
