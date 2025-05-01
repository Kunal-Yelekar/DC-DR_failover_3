provider "aws" {
  region = var.aws_region
}

# ==================================================
# VPC Modules: Create DC_VPC and DR_VPC
# ==================================================
module "dc_vpc" {
  source              = "./modules/vpc"
  vpc_name            = "DC_VPC"
  cidr_block          = var.dc_vpc_cidr
  aws_region          = var.aws_region
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.dc_public_subnet_cidrs
  admin_ips           = var.admin_ips
}

module "dr_vpc" {
  source              = "./modules/vpc"
  vpc_name            = "DR_VPC"
  cidr_block          = var.dr_vpc_cidr
  aws_region          = var.aws_region
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.dr_public_subnet_cidrs
  admin_ips           = var.admin_ips
}

# ==================================================
# VPC Peering: Establish communication between DC and DR
# ==================================================
resource "aws_vpc_peering_connection" "dc_dr_peering" {
  vpc_id      = module.dc_vpc.vpc_id
  peer_vpc_id = module.dr_vpc.vpc_id
  auto_accept = true

  tags = {
    Name = "dc-dr-peering"
  }
}

resource "aws_route" "dc_to_dr" {
  route_table_id            = module.dc_vpc.public_rt_id
  destination_cidr_block    = module.dr_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.dc_dr_peering.id
}

resource "aws_route" "dr_to_dc" {
  route_table_id            = module.dr_vpc.public_rt_id
  destination_cidr_block    = module.dc_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.dc_dr_peering.id
}

# ==================================================
# EC2 Instances: Deploy instances in DC and DR
# ==================================================
module "dc_ec2" {
  source            = "./modules/ec2"
  instance_name     = "dc-ec2-instance"
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = element(module.dc_vpc.public_subnet_ids, 0)
  security_group_id = module.dc_vpc.ec2_sg_id
}

module "dr_ec2" {
  source            = "./modules/ec2"
  instance_name     = "dr-ec2-instance"
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = element(module.dr_vpc.public_subnet_ids, 0)
  security_group_id = module.dr_vpc.ec2_sg_id
}

# ==================================================
# ALBs & Target Groups: Set up ALBs in each VPC with WAF integration
# ==================================================
module "dc_alb" {
  source              = "./modules/alb"
  alb_name            = "dc-alb"
  vpc_id              = module.dc_vpc.vpc_id
  subnets             = module.dc_vpc.public_subnet_ids
  target_instance_ids = [module.dc_ec2.instance_id]
  security_group_ids  = [module.dc_vpc.alb_sg_id]
}

module "dr_alb" {
  source              = "./modules/alb"
  alb_name            = "dr-alb"
  vpc_id              = module.dr_vpc.vpc_id
  subnets             = module.dr_vpc.public_subnet_ids
  target_instance_ids = [module.dr_ec2.instance_id]
  security_group_ids  = [module.dr_vpc.alb_sg_id]
}

# ==================================================
# Global Accelerator: Configure for failover between DC and DR ALBs
# ==================================================
module "global_accelerator" {
  source            = "./modules/global_accelerator"
  accelerator_name  = "my-global-accelerator"
  listener_port     = 80
  endpoint_configs  = [
    {
      endpoint_id = module.dc_alb.alb_arn
      weight      = 128
    },
    {
      endpoint_id = module.dr_alb.alb_arn
      weight      = 128
    }
  ]
}
