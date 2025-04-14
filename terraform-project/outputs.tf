output "dc_vpc_id" {
  value = module.dc_vpc.vpc_id
}

output "dr_vpc_id" {
  value = module.dr_vpc.vpc_id
}

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "dc_instance_id" {
  value = module.dc_instance.instance_id
}

output "dr_instance_id" {
  value = module.dr_instance.instance_id
}
