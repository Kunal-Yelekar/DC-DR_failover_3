provider "aws" {
  region = var.region
}

# ---------- VPC Modules ----------
module "dc_vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.dc_vpc_cidr
  vpc_name           = "DC_VPC"
  availability_zones = var.dc_availability_zones
  public_subnets     = var.dc_public_subnets
}

module "dr_vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.dr_vpc_cidr
  vpc_name           = "DR_VPC"
  availability_zones = var.dr_availability_zones
  public_subnets     = var.dr_public_subnets
}

# ---------- VPC Peering ----------
resource "aws_vpc_peering_connection" "dc_dr_peering" {
  vpc_id      = module.dc_vpc.vpc_id
  peer_vpc_id = module.dr_vpc.vpc_id
  peer_region = var.region
  auto_accept = true
  tags = {
    Name = "DC-DR-Peering"
  }
}

resource "aws_route" "dc_to_dr_peering" {
  route_table_id            = module.dc_vpc.public_route_table_id
  destination_cidr_block    = module.dr_vpc.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.dc_dr_peering.id
}

resource "aws_route" "dr_to_dc_peering" {
  route_table_id            = module.dr_vpc.public_route_table_id
  destination_cidr_block    = module.dc_vpc.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.dc_dr_peering.id
}

# ---------- Security Groups Modules ----------
module "dc_sec_groups" {
  source           = "./modules/security_groups"
  vpc_id           = module.dc_vpc.vpc_id
  project_name     = "DC"
  alb_ingress_port = var.alb_ingress_port
  allowed_sources  = var.allowed_sources
  ec2_allowed_port = var.ec2_allowed_port
  admin_port       = var.admin_port
  admin_ip_cidr    = var.admin_ip_cidr
}

module "dr_sec_groups" {
  source           = "./modules/security_groups"
  vpc_id           = module.dr_vpc.vpc_id
  project_name     = "DR"
  alb_ingress_port = var.alb_ingress_port
  allowed_sources  = var.allowed_sources
  ec2_allowed_port = var.ec2_allowed_port
  admin_port       = var.admin_port
  admin_ip_cidr    = var.admin_ip_cidr
}

# ---------- EC2 Modules ----------
module "dc_ec2" {
  source         = "./modules/ec2"
  instance_count = var.dc_instance_count
  ami_id         = var.dc_ami_id
  instance_type  = var.dc_instance_type
  subnet_id      = module.dc_vpc.public_subnet_ids[0]
  sg_ids         = [module.dc_sec_groups.ec2_sg_id]
  instance_name  = "DC-EC2"
}

module "dr_ec2" {
  source         = "./modules/ec2"
  instance_count = var.dr_instance_count
  ami_id         = var.dr_ami_id
  instance_type  = var.dr_instance_type
  subnet_id      = module.dr_vpc.public_subnet_ids[0]
  sg_ids         = [module.dr_sec_groups.ec2_sg_id]
  instance_name  = "DR-EC2"
}

# ---------- ALB Modules ----------
module "dc_alb" {
  source                     = "./modules/alb"
  alb_name                   = "DC_ALB"
  vpc_id                     = module.dc_vpc.vpc_id
  subnet_ids                 = module.dc_vpc.public_subnet_ids
  sg_ids                     = [module.dc_sec_groups.alb_sg_id]
  alb_target_group_name      = "DC_TG"
  target_group_port          = var.alb_target_group_port
  target_group_protocol      = var.alb_target_group_protocol
  listener_port              = var.alb_listener_port
  listener_protocol          = var.alb_listener_protocol
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_timeout       = var.health_check_timeout
  health_check_interval      = var.health_check_interval
  health_check_matcher       = var.health_check_matcher
  health_check_path          = var.health_check_path
  waf_name                   = "DC_WAF"
}

module "dr_alb" {
  source                     = "./modules/alb"
  alb_name                   = "DR_ALB"
  vpc_id                     = module.dr_vpc.vpc_id
  subnet_ids                 = module.dr_vpc.public_subnet_ids
  sg_ids                     = [module.dr_sec_groups.alb_sg_id]
  alb_target_group_name      = "DR_TG"
  target_group_port          = var.alb_target_group_port
  target_group_protocol      = var.alb_target_group_protocol
  listener_port              = var.alb_listener_port
  listener_protocol          = var.alb_listener_protocol
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_timeout       = var.health_check_timeout
  health_check_interval      = var.health_check_interval
  health_check_matcher       = var.health_check_matcher
  health_check_path          = var.health_check_path
  waf_name                   = "DR_WAF"
}

# ---------- Global Accelerator Module ----------
module "global_accelerator" {
  source                           = "./modules/global_accelerator"
  accelerator_name                 = "MyGlobalAccelerator"
  endpoint_alb_dc                  = module.dc_alb.alb_arn
  endpoint_alb_dr                  = module.dr_alb.alb_arn
  health_check_interval            = var.ga_health_check_interval
  endpoint_threshold_count         = var.ga_threshold_count
  global_accelerator_listener_port = var.ga_listener_port
  global_accelerator_protocol      = var.ga_listener_protocol
}
