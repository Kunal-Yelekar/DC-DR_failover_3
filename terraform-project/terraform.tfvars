aws_region     = "ap-south-2"
dc_vpc_cidr    = "10.0.0.0/16"
dr_vpc_cidr    = "10.1.0.0/16"
dc_azs         = ["ap-south-2a"]
dr_azs         = ["ap-south-2b"]
failover       = false
ami            = "ami-0abcdef1234567890"
instance_type  = "t2.micro"
