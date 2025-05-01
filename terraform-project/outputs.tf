output "dc_vpc_id" {
  value = module.dc_vpc.vpc_id
}

output "dr_vpc_id" {
  value = module.dr_vpc.vpc_id
}

output "dc_alb_dns" {
  value = module.dc_alb.alb_dns
}

output "dr_alb_dns" {
  value = module.dr_alb.alb_dns
}

output "global_accelerator_dns" {
  value = module.global_accelerator.accelerator_dns
}
