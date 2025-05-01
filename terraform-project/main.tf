# ------------------------------
# Create VPCs for DC and DR
# ------------------------------

module "dc_vpc" {
  source                = "./modules/vpc"
  vpc_name              = "DC_VPC"
  vpc_cidr              = var.dc_vpc_cidr
  public_subnet_cidrs   = var.dc_public_subnets
  private_subnet_cidrs  = var.dc_private_subnets
  azs                   = var.azs
}

module "dr_vpc" {
  source                = "./modules/vpc"
  vpc_name              = "DR_VPC"
  vpc_cidr              = var.dr_vpc_cidr
  public_subnet_cidrs   = var.dr_public_subnets
  private_subnet_cidrs  = var.dr_private_subnets
  azs                   = var.azs
}

# ------------------------------
# VPC Peering between DC and DR
# ------------------------------

resource "aws_vpc_peering_connection" "dc_dr" {
  vpc_id      = module.dc_vpc.vpc_id
  peer_vpc_id = module.dr_vpc.vpc_id
  auto_accept = true

  tags = {
    Name = "DC-DR-Peering"
  }
}

# Update route tables so traffic between VPCs goes via the peering connection.
resource "aws_route" "dc_to_dr" {
  route_table_id              = module.dc_vpc.public_route_table_id
  destination_cidr_block      = var.dr_vpc_cidr
  vpc_peering_connection_id   = aws_vpc_peering_connection.dc_dr.id
}

resource "aws_route" "dr_to_dc" {
  route_table_id              = module.dr_vpc.public_route_table_id
  destination_cidr_block      = var.dc_vpc_cidr
  vpc_peering_connection_id   = aws_vpc_peering_connection.dc_dr.id
}

# ------------------------------
# Security Groups
# ------------------------------

module "dc_security_groups" {
  source           = "./modules/security_groups"
  vpc_id           = module.dc_vpc.vpc_id
  alb_sg_name      = "DC_ALB_SG"
  ec2_sg_name      = "DC_EC2_SG"
  alb_ingress_port = 80
  alb_ingress_cidrs = ["0.0.0.0/0"]
  ec2_ingress_port  = 80
  admin_cidrs      = var.admin_cidrs
}

module "dr_security_groups" {
  source           = "./modules/security_groups"
  vpc_id           = module.dr_vpc.vpc_id
  alb_sg_name      = "DR_ALB_SG"
  ec2_sg_name      = "DR_EC2_SG"
  alb_ingress_port = 80
  alb_ingress_cidrs = ["0.0.0.0/0"]
  ec2_ingress_port  = 80
  admin_cidrs      = var.admin_cidrs
}

# ------------------------------
# Compute Resources (EC2)
# ------------------------------

module "dc_ec2" {
  source              = "./modules/ec2"
  instance_name       = "DC_EC2"
  vpc_id              = module.dc_vpc.vpc_id
  subnet_id           = element(module.dc_vpc.public_subnets, 0)
  instance_ami        = var.ec2_ami
  instance_type       = var.ec2_instance_type
  key_name            = var.key_name
  security_group_ids  = [module.dc_security_groups.ec2_sg_id]
}

module "dr_ec2" {
  source              = "./modules/ec2"
  instance_name       = "DR_EC2"
  vpc_id              = module.dr_vpc.vpc_id
  subnet_id           = element(module.dr_vpc.public_subnets, 0)
  instance_ami        = var.ec2_ami
  instance_type       = var.ec2_instance_type
  key_name            = var.key_name
  security_group_ids  = [module.dr_security_groups.ec2_sg_id]
}

# ------------------------------
# Application Load Balancers (ALB)
# ------------------------------

module "dc_alb" {
  source              = "./modules/alb"
  alb_name            = "DC_ALB"
  vpc_id              = module.dc_vpc.vpc_id
  subnet_ids          = module.dc_vpc.public_subnets
  security_group_ids  = [module.dc_security_groups.alb_sg_id]
  target_protocol     = "HTTP"
  target_port         = 80
  listener_protocol   = "HTTP"
  listener_port       = 80
  health_check_protocol = "HTTP"
  health_check_port   = 80
  health_check_path   = "/"
  waf_name            = "DC_WAF"
}

module "dr_alb" {
  source              = "./modules/alb"
  alb_name            = "DR_ALB"
  vpc_id              = module.dr_vpc.vpc_id
  subnet_ids          = module.dr_vpc.public_subnets
  security_group_ids  = [module.dr_security_groups.alb_sg_id]
  target_protocol     = "HTTP"
  target_port         = 80
  listener_protocol   = "HTTP"
  listener_port       = 80
  health_check_protocol = "HTTP"
  health_check_port   = 80
  health_check_path   = "/"
  waf_name            = "DR_WAF"
}

# ------------------------------
# Global Accelerator for Failover
# ------------------------------

module "global_accelerator" {
  source             = "./modules/global_accelerator"
  ga_name            = "Global_Accel"
  listener_protocol  = "TCP"
  listener_port      = 80
  dc_alb_arn         = module.dc_alb.alb_arn
  dr_alb_arn         = module.dr_alb.alb_arn
}

# ------------------------------
# (Optional) CloudWatch Alarms, Backup, etc.
# ------------------------------
# Add resources as needed for monitoring and backup.
