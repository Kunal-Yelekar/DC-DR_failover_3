variable "name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "List of availability zones to deploy subnets in"
  type        = list(string)
}
