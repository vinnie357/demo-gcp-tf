#outputs
# output "f5vm01_mgmt_public_ip" {
#   value = "${module.firewall.f5vm01_mgmt_public_ip}"
# }
# output "f5vm02_mgmt_public_ip" {
#   value = "${module.firewall.f5vm02_mgmt_public_ip}"
# }

# output "f5vm01_app_public_ip" {
#   value = "${module.firewall.f5vm01_app_public_ip}"
# }
# output "f5vm02_app_public_ip" {
#   value = "${module.firewall.f5vm02_app_public_ip}"
# }

# output "load_balancer_ip_address" {
#   description = "IP address of the Load Balancer"
#   value       = "${module.firewall.load_balancer_ip_address}"
# }

output "device_mgmt_ips" { value = "${module.firewall.device_mgmt_ips}"}
