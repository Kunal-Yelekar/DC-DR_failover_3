output "dc_vpc_id" {
  description = "DC VPC ID"
  value       = module.dc_vpc.vpc_id
}

output "dr_vpc_id" {
  description = "DR VPC ID"
  value       = module.dr_vpc.vpc_id
}

output "dc_alb_dns" {
  description = "DC ALB DNS Name"
  value       = module.dc_alb.alb_dns_name
}

output "dr_alb_dns" {
  description = "DR ALB DNS Name"
  value       = module.dr_alb.alb_dns_name
}

output "global_accelerator_dns" {
  description = "Global Accelerator DNS Name"
  value       = module.global_accelerator.ga_dns_name
}
