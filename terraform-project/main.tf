provider "aws" {
  region = var.default_region
}

#######################
# VPC Creation Modules
#######################

module "dc_vpc" {
  source             = "./modules/vpc"
  vpc_name           = "DC_VPC"
  vpc_cidr           = var.dc_vpc_cidr
  public_subnets     = var.dc_public_subnets
  private_subnets    = var.dc_private_subnets
  availability_zones = var.dc_azs
  environment        = "DC"
}

module "dr_vpc" {
  source             = "./modules/vpc"
  vpc_name           = "DR_VPC"
  vpc_cidr           = var.dr_vpc_cidr
  public_subnets     = var.dr_public_subnets
  private_subnets    = var.dr_private_subnets
  availability_zones = var.dr_azs
  environment        = "DR"
}

#############################
# VPC Peering & Route Setup
#############################

resource "aws_vpc_peering_connection" "dc_dr_peering" {
  vpc_id       = module.dc_vpc.vpc_id
  peer_vpc_id  = module.dr_vpc.vpc_id
  peer_region  = var.default_region
  auto_accept  = true

  tags = {
    Name = "DC-DR-Peering"
  }
}

resource "aws_route" "dc_to_dr" {
  route_table_id              = module.dc_vpc.public_route_table_id
  destination_cidr_block      = var.dr_vpc_cidr
  vpc_peering_connection_id   = aws_vpc_peering_connection.dc_dr_peering.id
}

resource "aws_route" "dr_to_dc" {
  route_table_id              = module.dr_vpc.public_route_table_id
  destination_cidr_block      = var.dc_vpc_cidr
  vpc_peering_connection_id   = aws_vpc_peering_connection.dc_dr_peering.id
}

#############################
# EC2 Instance Deployment
#############################

module "dc_ec2" {
  source             = "./modules/ec2"
  instance_count     = var.dc_instance_count
  ami                = var.ami
  instance_type      = var.dc_instance_type
  subnet_ids         = module.dc_vpc.public_subnet_ids
  security_group_ids = [var.dc_ec2_sg]
  environment        = "DC"
  tags               = var.tags
}

module "dr_ec2" {
  source             = "./modules/ec2"
  instance_count     = var.dr_instance_count
  ami                = var.ami
  instance_type      = var.dr_instance_type
  subnet_ids         = module.dr_vpc.public_subnet_ids
  security_group_ids = [var.dr_ec2_sg]
  environment        = "DR"
  tags               = var.tags
}

#############################################
# ALB & Target Group with WAF Integration
#############################################

module "dc_alb" {
  source                = "./modules/alb"
  environment           = "DC"
  subnet_ids            = module.dc_vpc.public_subnet_ids
  security_group_ids    = [var.dc_alb_sg]
  target_group_port     = var.target_group_port
  target_group_protocol = var.target_group_protocol
  health_check_path     = var.health_check_path
  health_check_matcher  = var.health_check_matcher
  listener_port         = var.listener_port
  listener_protocol     = var.listener_protocol
  vpc_id                = module.dc_vpc.vpc_id
  tags                  = var.tags
}

module "dr_alb" {
  source                = "./modules/alb"
  environment           = "DR"
  subnet_ids            = module.dr_vpc.public_subnet_ids
  security_group_ids    = [var.dr_alb_sg]
  target_group_port     = var.target_group_port
  target_group_protocol = var.target_group_protocol
  health_check_path     = var.health_check_path
  health_check_matcher  = var.health_check_matcher
  listener_port         = var.listener_port
  listener_protocol     = var.listener_protocol
  vpc_id                = module.dr_vpc.vpc_id
  tags                  = var.tags
}

##################################
# Global Accelerator Setup Module
##################################

module "global_accelerator" {
  source                   = "./modules/ga"
  environment              = "GA"
  region                   = var.default_region
  dc_alb_arn               = module.dc_alb.alb_arn
  dr_alb_arn               = module.dr_alb.alb_arn
  ga_listener_port         = var.ga_listener_port
  ga_listener_protocol     = var.ga_listener_protocol
  ga_health_check_port     = var.ga_health_check_port
  ga_health_check_protocol = var.ga_health_check_protocol
}

##################################
# Monitoring: CloudWatch Alarms
##################################

resource "aws_cloudwatch_metric_alarm" "dc_alb_unhealthy_hosts" {
  alarm_name          = "DC-ALB-Unhealthy-Hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Alarm when unhealthy host count is greater than 1"
  dimensions = {
    LoadBalancer = module.dc_alb.alb_arn
  }
}

resource "aws_cloudwatch_metric_alarm" "dr_alb_unhealthy_hosts" {
  alarm_name          = "DR-ALB-Unhealthy-Hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Alarm when unhealthy host count is greater than 1"
  dimensions = {
    LoadBalancer = module.dr_alb.alb_arn
  }
}

##################################
# Backup – Using AWS Backup Vault
##################################

resource "aws_backup_vault" "this" {
  name = "${var.environment}-backup-vault"
  tags = var.tags
}

resource "aws_backup_plan" "this" {
  name = "${var.environment}-backup-plan"
  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 12 * * ? *)"
    lifecycle {
      cold_storage_after = 30
      delete_after       = 90
    }
  }
}
