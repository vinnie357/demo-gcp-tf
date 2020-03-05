# GCP
# output "gcp_bigip01_app" {
#   value = "https://${module.gcp.f5vm01_app_public_ip}"
# }
# output "gcp_bigip02_app" {
#   value = "https://${module.gcp.f5vm02_app_public_ip}"
# }
output "gcp_bigip01_mgmt" {
  value = "https://${module.gcp.f5vm01_mgmt_public_ip}"
}
output "gcp_bigip02_mgmt" {
  value = "https://${module.gcp.f5vm02_mgmt_public_ip}"
}
# output "firewall_selflinks" {
#     value = "${module.gcp.firewall_selflinks}"
# }

# ------------------------------------------------------------------------------
# GOOGLE LOAD BALANCER OUTPUTS
# ------------------------------------------------------------------------------

# output "forwarding_rule" {
#   description = "Self link of the forwarding rule (Load Balancer)"
#   value       = module.gcp.forwarding_rule
# }

output "load_balancer_ip_address" {
  description = "IP address of the Load Balancer"
  value       = "https://${module.gcp.load_balancer_ip_address}"
}

output "buildSuffix" {
  value = "-${random_pet.buildSuffix.id}"
}
