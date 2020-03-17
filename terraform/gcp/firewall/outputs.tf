#
output "firewall01" {
    value = "google_compute_instance.vm_instance[0]"
}
output "firewall02" {
    value = "google_compute_instance.vm_instance[1]"
}
#output "f5vm01_mgmt_public_ip" { value = "${google_compute_instance.vm_instance.0.network_interface.1.access_config.0.nat_ip}" }
#output "f5vm01_app_public_ip" { value = "${google_compute_instance.vm_instance.0.network_interface.0.access_config.0.nat_ip}" }

#output "f5vm02_mgmt_public_ip" { value = "${var.vm_count >= 2 ? "${google_compute_instance.vm_instance.1.network_interface.1.access_config.0.nat_ip}" : "none"}"}
#output "f5vm02_app_public_ip" { value = "${var.vm_count >= 2 ? "${google_compute_instance.vm_instance.1.network_interface.0.access_config.0.nat_ip}" : "none" }"}

#output "device_mgmt_ips" { value = google_compute_instance.vm_instance.*.network_interface.1.access_config.0.nat_ip }
# output "device_mgmt_ips2" { value = google_compute_instance.vm_instance[0] }
output "device_mgmt_ips" {
  # Result is a map from instance id to private IP address, such as:
  #  {"i-1234" = "192.168.1.2", "i-5678" = "192.168.1.5"}
  value = {
    for instance in google_compute_instance.vm_instance:
    instance.name => "https://${instance.network_interface.1.access_config.0.nat_ip}"
  }
}

# output "selflinks" {
#     value = "${google_compute_instance.vm_instance.*.self_link}"
# }

# # ------------------------------------------------------------------------------
# # LOAD BALANCER OUTPUTS
# # ------------------------------------------------------------------------------

# output "forwarding_rule" {
#   description = "Self link of the forwarding rule (Load Balancer)"
#   value       = google_compute_forwarding_rule.default.self_link
# }

# output "load_balancer_ip_address" {
#   description = "IP address of the Load Balancer"
#   value       = google_compute_global_forwarding_rule.default_tcp.ip_address
# }
