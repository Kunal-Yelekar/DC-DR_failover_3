module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
}

module "alb_sg" {
  source        = "./modules/alb_sg"
  vpc_id        = module.vpc.vpc_id
  allowed_ports = var.alb_allowed_ports
}

module "instance_sg" {
  source     = "./modules/instance_sg"
  vpc_id    = module.vpc.vpc_id
  alb_sg_id = module.alb_sg.sg_id
}

module "waf" {
  source         = "./modules/waf"
  name           = var.waf_name
  scope          = var.waf_scope
  default_action = var.waf_default_action
}

module "ec2" {
  source         = "./modules/ec2"
  vpc_id         = module.vpc.vpc_id
  # Deploy the instance into one of the private subnets (choose index 0)
  subnet_id      = module.vpc.private_subnet_ids[0]
  instance_sg_id = module.instance_sg.sg_id
  instance_type  = var.instance_type
  ami_id         = var.ami_id
}

module "alb" {
  source                 = "./modules/alb"
  vpc_id                 = module.vpc.vpc_id
  public_subnets         = module.vpc.public_subnet_ids
  alb_sg_id              = module.alb_sg.sg_id
  target_group_port      = var.target_group_port
  target_group_protocol  = var.target_group_protocol
  instance_id            = module.ec2.instance_id
  waf_acl_arn            = module.waf.waf_acl_arn
}
