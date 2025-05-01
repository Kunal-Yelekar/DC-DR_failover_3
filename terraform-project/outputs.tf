output "dc_vpc_id" {
  description = "DC VPC ID"
  value       = module.dc_vpc.vpc_id
}

output "dr_vpc_id" {
  description = "DR VPC ID"
  value       = module.dr_vpc.vpc_id
}

output "dc_alb_dns" {
  description = "DNS name of the DC ALB"
  value       = module.dc_alb.alb_dns_name
}

output "dr_alb_dns" {
  description = "DNS name of the DR ALB"
  value       = module.dr_alb.alb_dns_name
}

output "global_accelerator_dns" {
  description = "DNS name of the Global Accelerator"
  value       = module.global_accelerator.accelerator_dns_name
}

output "dc_ec2_instance_ids" {
  description = "EC2 instance IDs in the DC VPC"
  value       = module.dc_ec2.instance_ids
}

output "dr_ec2_instance_ids" {
  description = "EC2 instance IDs in the DR VPC"
  value       = module.dr_ec2.instance_ids
}
