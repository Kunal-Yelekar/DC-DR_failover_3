region                = "ap-south-1"

# Backend configuration
backend_bucket         = "your-terraform-backend-bucket"
backend_region         = "ap-south-1"
backend_dynamodb_table = "terraform-lock-table"

# VPC overrides (if needed; defaults are set in variables.tf)
dc_vpc_cidr           = "10.0.0.0/16"
dc_availability_zones = ["ap-south-1a", "ap-south-1b"]
dc_public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]

dr_vpc_cidr           = "10.1.0.0/16"
dr_availability_zones = ["ap-south-1a", "ap-south-1b"]
dr_public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]

# EC2 settings
dc_instance_count     = 1
dc_ami_id             = "ami-0abcdef1234567890"
dc_instance_type      = "t2.micro"

dr_instance_count     = 1
dr_ami_id             = "ami-0abcdef1234567890"
dr_instance_type      = "t2.micro"

# ALB settings
alb_ingress_port          = 80
alb_target_group_port     = 80
alb_target_group_protocol = "HTTP"
alb_listener_port         = 80
alb_listener_protocol     = "HTTP"
health_check_healthy_threshold   = 3
health_check_unhealthy_threshold = 3
health_check_timeout      = 5
health_check_interval     = 30
health_check_path         = "/health"
health_check_matcher      = "200-299"

# Global Accelerator settings
ga_health_check_interval = 30
ga_threshold_count       = 3
ga_listener_port         = 80
ga_listener_protocol     = "TCP"

# Security Groups
allowed_sources      = ["0.0.0.0/0"]
ec2_allowed_port     = 80
admin_port           = 22
admin_ip_cidr        = ["203.0.113.0/32"]  # Replace with your admin IP(s)
