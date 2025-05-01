backend_bucket         = "my-terraform-backend-bucket"
backend_key            = "project/terraform.tfstate"
backend_region         = "ap-south-1"
backend_dynamodb_table = "terraform-locks"

environment            = "production"
default_region         = "ap-south-1"

tags = {
  Project   = "AWS-DR-DC"
  ManagedBy = "Terraform"
}

# VPC settings
dc_vpc_cidr            = "10.0.0.0/16"
dr_vpc_cidr            = "10.1.0.0/16"

dc_public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
dr_public_subnets      = ["10.1.1.0/24", "10.1.2.0/24"]

dc_private_subnets     = ["10.0.101.0/24", "10.0.102.0/24"]
dr_private_subnets     = ["10.1.101.0/24", "10.1.102.0/24"]

dc_azs                 = ["ap-south-1a", "ap-south-1b"]
dr_azs                 = ["ap-south-1a", "ap-south-1b"]

# EC2 settings
dc_instance_count      = 2
dr_instance_count      = 2
ami                    = "ami-0abcdef1234567890"
dc_instance_type       = "t3.micro"
dr_instance_type       = "t3.micro"

dc_ec2_sg              = "sg-0123456789abcdef0"
dr_ec2_sg              = "sg-0123456789abcdef1"

# ALB settings
dc_alb_sg              = "sg-0abcdef1234567890"
dr_alb_sg              = "sg-0abcdef1234567891"
target_group_port      = 80
target_group_protocol  = "HTTP"
health_check_path      = "/health"
health_check_matcher   = "200"
listener_port          = 80
listener_protocol      = "HTTP"

# Global Accelerator settings
ga_listener_port       = 80
ga_listener_protocol   = "TCP"
ga_health_check_port   = 80
ga_health_check_protocol = "HTTP"
