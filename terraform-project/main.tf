provider "aws" {
  region = var.aws_region
}

#############################
# Create DC and DR VPCs
#############################
module "dc_vpc" {
  source = "./modules/vpc"
  name   = "dc-vpc"
  cidr   = var.dc_vpc_cidr
  azs    = var.dc_azs
}

module "dr_vpc" {
  source = "./modules/vpc"
  name   = "dr-vpc"
  cidr   = var.dr_vpc_cidr
  azs    = var.dr_azs
}

#############################
# Create VPC Peering & Routes
#############################
resource "aws_vpc_peering_connection" "dc_dr" {
  vpc_id      = module.dc_vpc.vpc_id
  peer_vpc_id = module.dr_vpc.vpc_id
  peer_region = var.aws_region
  auto_accept = true
  tags = {
    Name = "dc-dr-peering"
  }
}

# In each public route table, add a route to the peer VPC via the peering connection.
resource "aws_route" "dc_to_dr" {
  for_each                   = toset(module.dc_vpc.route_table_ids)
  route_table_id             = each.value
  destination_cidr_block     = var.dr_vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.dc_dr.id
}

resource "aws_route" "dr_to_dc" {
  for_each                   = toset(module.dr_vpc.route_table_ids)
  route_table_id             = each.value
  destination_cidr_block     = var.dc_vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.dc_dr.id
}

#############################
# Security Groups
#############################
# ALB Security Group (allow ports 80,443,22 from anywhere)
module "alb_sg" {
  source = "./modules/alb_sg"
  name   = "alb-sg"
  vpc_id = module.dc_vpc.vpc_id
}

# Instance Security Group (allow inbound only from ALB)
module "instance_sg" {
  source    = "./modules/instance_sg"
  name      = "instance-sg"
  vpc_id    = module.dc_vpc.vpc_id   # For your DC instances (similarly, you could create a separate instance SG in the DR VPC if desired)
  alb_sg_id = module.alb_sg.sg_id
}

#############################
# Target Groups Creation
#############################
module "dc_target_group" {
  source            = "./modules/target_group"
  name              = "dc-tg"
  vpc_id            = module.dc_vpc.vpc_id
  protocol          = "HTTP"
  port              = 80
  health_check_path = "/"
}

module "dr_target_group" {
  source            = "./modules/target_group"
  name              = "dr-tg"
  vpc_id            = module.dr_vpc.vpc_id
  protocol          = "HTTP"
  port              = 80
  health_check_path = "/"
}

#############################
# Create an Application Load Balancer in DC VPC
#############################
module "alb" {
  source              = "./modules/alb"
  name                = "dc-alb"
  subnets             = module.dc_vpc.public_subnets
  sg_ids              = [module.alb_sg.sg_id]
  load_balancer_type  = "application"
  ip_address_type     = "ipv4"
}

# ALB Listener with weighted target groups.
# By toggling the "failover" variable, you manually shift traffic.
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = module.alb.alb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn    = module.dc_target_group.tg_arn
        weight = var.failover ? 0 : 100
      }
      target_group {
        arn    = module.dr_target_group.tg_arn
        weight = var.failover ? 100 : 0
      }
    }
  }
}

#############################
# Deploy EC2 Instances in DC and DR VPCs
#############################
module "dc_instance" {
  source        = "./modules/ec2-instance"
  name          = "dc-instance"
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = element(module.dc_vpc.public_subnets, 0)
  sg_ids        = [module.instance_sg.sg_id]
}

module "dr_instance" {
  source        = "./modules/ec2-instance"
  name          = "dr-instance"
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = element(module.dr_vpc.public_subnets, 0)
  sg_ids        = [module.instance_sg.sg_id]
}

# Attach instances to their respective target groups
resource "aws_lb_target_group_attachment" "dc_instance_attachment" {
  target_group_arn = module.dc_target_group.tg_arn
  target_id        = module.dc_instance.instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "dr_instance_attachment" {
  target_group_arn = module.dr_target_group.tg_arn
  target_id        = module.dr_instance.instance_id
  port             = 80
}

#############################
# Configure AWS WAF (WAFv2) and Associate with ALB
#############################
module "waf" {
  source = "./modules/waf"
  name   = "alb-waf"
  scope  = "REGIONAL"
  default_action    = {
    allow = {}
  }
  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = "wafMetric"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "waf_alb_assoc" {
  resource_arn = module.alb.alb_arn
  web_acl_arn  = module.waf.web_acl_arn
}

#############################
# Note on Data Replication
#############################
# Data replication between DC and DR (for example, using a database replication mechanism)
# is expected to be implemented externally or within a separate module.
