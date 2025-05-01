region              = "ap-south-1"
state_bucket        = "my-terraform-state-bucket"
dynamodb_lock_table = "terraform-lock-table"
env                 = "production"

dc_vpc_cidr         = "10.0.0.0/16"
dr_vpc_cidr         = "10.1.0.0/16"

dc_public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
dr_public_subnets   = ["10.1.1.0/24", "10.1.2.0/24"]

azs                 = ["ap-south-1a", "ap-south-1b"]

admin_cidrs         = ["203.0.113.0/24"]

ec2_ami             = "ami-0abcdef1234567890"
ec2_instance_type   = "t2.micro"
key_name            = "my-key"
