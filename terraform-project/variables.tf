// Global provider and environment settings
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-south-1"
}

# --------- VPC Variables for DC ---------
variable "dc_vpc_cidr" {
  description = "CIDR for the DC VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dc_availability_zones" {
  description = "List of Availability Zones for DC VPC"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "dc_public_subnets" {
  description = "CIDR blocks for DC public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# --------- VPC Variables for DR ---------
variable "dr_vpc_cidr" {
  description = "CIDR for the DR VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "dr_availability_zones" {
  description = "List of Availability Zones for DR VPC"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "dr_public_subnets" {
  description = "CIDR blocks for DR public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

# --------- EC2 Variables ---------
variable "dc_instance_count" {
  description = "Number of EC2 instances for the DC environment"
  type        = number
  default     = 1
}

variable "dc_ami_id" {
  description = "AMI ID for DC EC2 instance"
  type        = string
  default     = "ami-0e35ddab05955cf57"
}

variable "dc_instance_type" {
  description = "Instance type for DC EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "dr_instance_count" {
  description = "Number of EC2 instances for the DR environment"
  type        = number
  default     = 1
}

variable "dr_ami_id" {
  description = "AMI ID for DR EC2 instance"
  type        = string
  default     = "ami-0e35ddab05955cf57"
}

variable "dr_instance_type" {
  description = "Instance type for DR EC2 instance"
  type        = string
  default     = "t2.micro"
}

# --------- ALB Variables ---------
variable "alb_ingress_port" {
  description = "Port for ALB ingress"
  type        = number
  default     = 80
}

variable "alb_target_group_port" {
  description = "Port for ALB target groups"
  type        = number
  default     = 80
}

variable "alb_target_group_protocol" {
  description = "Protocol for ALB target groups (HTTP/HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "alb_listener_port" {
  description = "ALB listener port"
  type        = number
  default     = 80
}

variable "alb_listener_protocol" {
  description = "ALB listener protocol (HTTP/HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "health_check_healthy_threshold" {
  description = "Healthy threshold value for ALB health checks"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Unhealthy threshold value for ALB health checks"
  type        = number
  default     = 3
}

variable "health_check_timeout" {
  description = "Health check timeout (in seconds)"
  type        = number
  default     = 5
}

variable "health_check_interval" {
  description = "Interval (in seconds) for ALB health checks"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "URL path for health check monitoring"
  type        = string
  default     = "/health"
}

variable "health_check_matcher" {
  description = "Expected HTTP status codes for a healthy response"
  type        = string
  default     = "200-299"
}

# --------- Global Accelerator Variables ---------
variable "ga_health_check_interval" {
  description = "Health check interval (in seconds) for Global Accelerator"
  type        = number
  default     = 30
}

variable "ga_threshold_count" {
  description = "Threshold count for Global Accelerator health checks"
  type        = number
  default     = 3
}

variable "ga_listener_port" {
  description = "Listener port for Global Accelerator"
  type        = number
  default     = 80
}

variable "ga_listener_protocol" {
  description = "Listener protocol for Global Accelerator (e.g. TCP)"
  type        = string
  default     = "TCP"
}

# --------- Security Groups Variables ---------
variable "allowed_sources" {
  description = "Allowed CIDR blocks for ALB ingress"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ec2_allowed_port" {
  description = "Port for traffic allowed from ALB to EC2 instances"
  type        = number
  default     = 80
}

variable "admin_port" {
  description = "Administrative port (e.g., SSH)"
  type        = number
  default     = 22
}

variable "admin_ip_cidr" {
  description = "CIDR blocks for administrative access"
  type        = list(string)
  default     = ["YOUR_ADMIN_IP/32"]
}


# --------- Backend Configuration Variables ---------
/*
variable "backend_bucket" {
  description = "S3 bucket for remote Terraform state"
  type        = string
}

variable "backend_region" {
  description = "AWS region for the backend S3 bucket"
  type        = string
}

variable "backend_dynamodb_table" {
  description = "DynamoDB table for state locking"
  type        = string
}
*/
