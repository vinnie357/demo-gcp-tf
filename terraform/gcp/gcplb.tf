# # Health checks
# # Health checks ensure that Compute Engine forwards new connections only to instances that are up and ready to receive them. Compute Engine sends health check requests to each instance at the specified frequency. 
# # After an instance exceeds its allowed number of health check failures, it is no longer considered an eligible instance for receiving new traffic. 
# # Existing connections are not actively terminated, which allows instances to shut down gracefully and close TCP connections.
# # The health checker continues to query unhealthy instances, and returns an instance to the pool when the specified number of successful checks occur. 
# # If all instances are marked as UNHEALTHY, the load balancer directs new traffic to all existing instances.
# # Network Load Balancing relies on legacy HTTP health checks to determine instance health. Even if your service does not use HTTP, you must run a basic web server on each instance that the health check system can query.

# # # ------------------------------------------------------------------------------
# # # CREATE THE INTERNAL TCP LOAD BALANCER
# # # ------------------------------------------------------------------------------

# # module "lb" {
# #   # When using these modules in your own templates, you will need to use a Git URL with a ref attribute that pins you
# #   # to a specific version of the modules, such as the following example:
# #   #source = "github.com/gruntwork-io/terraform-google-load-balancer.git//modules/network-load-balancer?ref=v0.2.0"
# #   source = "github.com/gruntwork-io/terraform-google-load-balancer.git//modules/network-load-balancer"
# #   #source = "modules/network-load-balancer"

# #   name    = "external-app-lb"
# #   region  = "us-east1"
# #   project = "var.project"

# #   enable_health_check = true
# #   health_check_port   = "443"
# #   health_check_path   = "/"

# #   firewall_target_tags = ["external-app-lb"]

# #   instances = [ module.firewall.firewall01, module.firewall.firewall02 ]

# #   custom_labels = var.custom_labels
# # }


# # ------------------------------------------------------------------------------
# # CREATE FORWARDING RULE
# # ------------------------------------------------------------------------------

# # resource "google_compute_forwarding_rule" "default" {
# #   #provider              = google-beta
# #   #project               = var.project
# #   name                  = var.name
# #   target                = google_compute_target_pool.default.self_link
# #   #target                = google_compute_instance_group.firewallext.self_link
# #   load_balancing_scheme = "EXTERNAL"
# #   port_range            = var.port_range
# #   ip_address            = var.ip_address
# #   ip_protocol           = var.protocol
# #   region                = var.region
# #   #labels = var.custom_labels
# #   #labels = {}
# # }

# # ------------------------------------------------------------------------------
# # CREATE TARGET POOL
# # ------------------------------------------------------------------------------

# resource "google_compute_target_pool" "default" {
#   #provider         = google-beta
#   #project          = var.project
#   name             = "${var.name}-tp"
#   region           = var.region
#   session_affinity = var.session_affinity

#   #instances = var.instances
#   #instances = [ module.firewall.firewall01.self_link, module.firewall.firewall02.self_link ]
#   #instances = ["${module.firewall.google_compute_instance.vm_instance.*.self_link}"]
#   #instances = [ mydomain-afm-1-instance, mydomain-afm-2-instance]
#   # "${var.zone + var.projectprefix + var.name var.instance.count or *-instance}"
#   #"${var.GCP_ZONE}/${var.projectprefix}${var.name}.*.-instance}"
#   #instances = ["${var.GCP_ZONE}/mydomain-afm-.*.-instance}" ]
#   instances = "${module.firewall.selflinks}"
#   #instances = [ "us-east1-b/mydomain-afm-1-instance","us-east1-b/mydomain-afm-2-instance" ]
#   # you have to pass the array becuase of the count work around to make the monitor optional
#   health_checks = google_compute_http_health_check.default.*.name
#   #health_checks = [ google_compute_https_health_check.default-https.name ]
#   #health_checks = google_compute_health_check.https-health-check.*.name
# }
# # fowarding rule
# resource "google_compute_forwarding_rule" "default" {
#   name                  = "firewall-forwarding-rule"
# #   region                = var.region
# #   load_balancing_scheme = "EXTERNAL"
# #   backend_service       = "${google_compute_region_backend_service.backend.self_link}"
#   #network               = "${google_compute_network.default.name}"
#   port_range            = 443
#   target                = google_compute_target_pool.default.self_link
#   #ports                 = ["80","443"]
#   #network               = "projects//global/networks/mydomain-terraform-network-ext"
#   #subnetwork            = "${google_compute_subnetwork.default.name}"
#   #subnetwork            = "projects//regions/us-east1/subnetworks/mydomain-ext-sub"
# }

# # backend
# # resource "google_compute_region_backend_service" "backend" {
# #   name                  = "firewall-backend"
# #   region                = var.region
# #   health_checks         = ["${google_compute_health_check.hc.self_link}"]
# #   backend {
# #     group          = google_compute_instance_group.firewallext.self_link  
# #   }
# # }
# # health check
# # resource "google_compute_health_check" "hc" {
# #   name               = "check-firewall-backend"
# #   check_interval_sec = 1
# #   timeout_sec        = 1
# #   tcp_health_check {
# #     port = "443"
# #   }
# # }
# # instance group
# resource "google_compute_instance_group" "firewallext" {
#     name = "mydomain-firewall-instance-group"
#     zone = "us-east1-b"
#     instances = "${module.firewall.selflinks}"
#     network = "projects//global/networks/mydomain-terraform-network-ext"
#     named_port {
#         name = "mgmt"
#         port = "443"
#     }
# }
# # ------------------------------------------------------------------------------
# # CREATE HEALTH CHECK
# # ------------------------------------------------------------------------------

# resource "google_compute_http_health_check" "default" {
#   count = var.enable_health_check ? 1 : 0

#   #provider            = google-beta
#   #project             = var.project
#   name                = "${var.name}-hc"
#   request_path        = var.health_check_path
#   port                = var.health_check_port
#   check_interval_sec  = var.health_check_interval
#   healthy_threshold   = var.health_check_healthy_threshold
#   unhealthy_threshold = var.health_check_unhealthy_threshold
#   timeout_sec         = var.health_check_timeout
# }

# # resource "google_compute_https_health_check" "default-https" {
# #   name         = "https-health-check"
# #   request_path = "/"

# #   timeout_sec        = 1
# #   check_interval_sec = 1
# # }

# # resource "google_compute_health_check" "https-health-check" {
# #   name = "https-health-check"

# #   timeout_sec        = 1
# #   check_interval_sec = 1

# #   https_health_check {
# #     port = "443"
# #   }
# # }

# # ------------------------------------------------------------------------------
# # CREATE FIREWALL FOR THE HEALTH CHECKS
# # ------------------------------------------------------------------------------

# # # Health check firewall allows ingress tcp traffic from the health check IP addresses
# resource "google_compute_firewall" "health_check" {
#   count = var.enable_health_check ? 1 : 0

#   #provider = google-beta
#   #project  = var.network_project == null ? var.project : var.network_project
#   name     = "${var.name}-hc-fw"
#   network  = "${google_compute_network.vpc_network_ext.name}"

#   allow {
#     protocol = "tcp"
#     ports    = [var.health_check_port]
#   }

#   # These IP ranges are required for health checks
#   source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

#   # Target tags define the instances to which the rule applies
#   target_tags = var.firewall_target_tags
# }


# # ---------------------------------------------------------------------------------------------------------------------
# # CREATE A FIREWALL RULE TO ALLOW TRAFFIC FROM ALL ADDRESSES
# # ---------------------------------------------------------------------------------------------------------------------

# # resource "google_compute_firewall" "firewall" {
# #   #project = "var.project"
# #   name    = "external-app-lb-fw"
# #   network   = "projects//global/networks/mydomain-terraform-network-ext"

# #   allow {
# #     protocol = "tcp"
# #     ports    = ["443"]
# #   }

# #   # These IP ranges are required for health checks
# #   source_ranges = ["0.0.0.0/0"]

# #   # Target tags define the instances to which the rule applies
# #   target_tags = ["external-app-lb","tfgcplb"]
# # }

# #
# # ---------------------------------------------------------------------------------------------------------------------
# # REQUIRED PARAMETERS
# # These variables are expected to be passed in by the operator
# # ---------------------------------------------------------------------------------------------------------------------

# variable "project" {
#   description = "The project ID to create the resources in."
#   type        = string
#   default = "myprojectId"
# }

# variable "region" {
#   description = "All resources will be launched in this region."
#   type        = string
#   default = "us-east1"
# }

# variable "name" {
#   description = "Name for the load balancer forwarding rule and prefix for supporting resources."
#   type        = string
#   default = "tfgcplb"
# }

# # ---------------------------------------------------------------------------------------------------------------------
# # OPTIONAL MODULE PARAMETERS
# # These variables have defaults, but may be overridden by the operator.
# # ---------------------------------------------------------------------------------------------------------------------

# variable "network" {
#   description = "Self link of the VPC network in which to deploy the resources."
#   type        = string
#   default     = "default"
# }

# variable "protocol" {
#   description = "The protocol for the backend and frontend forwarding rule. TCP or UDP."
#   type        = string
#   default     = "TCP"
# }

# variable "ip_address" {
#   description = "IP address of the load balancer. If empty, an IP address will be automatically assigned."
#   type        = string
#   default     = null
# }

# variable "port_range" {
#   description = "Only packets addressed to ports in the specified range will be forwarded to target. If empty, all packets will be forwarded."
#   type        = string
#   default     = null
# }

# variable "enable_health_check" {
#   description = "Flag to indicate if health check is enabled. If set to true, a firewall rule allowing health check probes is also created."
#   type        = bool
#   #default     = false
#   default     = true
# }

# variable "health_check_port" {
#   description = "The TCP port number for the HTTP health check request."
#   type        = number
#   default     = 80
#   #default     = 443
# }

# variable "health_check_healthy_threshold" {
#   description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is 2."
#   type        = number
#   default     = 2
# }

# variable "health_check_unhealthy_threshold" {
#   description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is 2."
#   type        = number
#   default     = 2
# }

# variable "health_check_interval" {
#   description = "How often (in seconds) to send a health check. Default is 5."
#   type        = number
#   default     = 5
# }

# variable "health_check_timeout" {
#   description = "How long (in seconds) to wait before claiming failure. The default value is 5 seconds. It is invalid for 'health_check_timeout' to have greater value than 'health_check_interval'"
#   type        = number
#   default     = 5
# }

# variable "health_check_path" {
#   description = "The request path of the HTTP health check request. The default value is '/'."
#   type        = string
#   default     = "/"
# }

# variable "firewall_target_tags" {
#   description = "List of target tags for the health check firewall rule."
#   type        = list(string)
#   default     = []
# }

# variable "network_project" {
#   description = "The name of the GCP Project where the network is located. Useful when using networks shared between projects. If empty, var.project will be used."
#   type        = string
#   default     = null
# }

# variable "session_affinity" {
#   description = "The session affinity for the backends, e.g.: NONE, CLIENT_IP. Default is `NONE`."
#   type        = string
#   #default     = "NONE"
#   default = "CLIENT_IP"
# }

# variable "instances" {
#   description = "List of self links to instances in the pool. Note that the instances need not exist at the time of target pool creation."
#   type        = list(string)
#   default     = []
# }

# variable "custom_labels" {
#   description = "A map of custom labels to apply to the resources. The key is the label name and the value is the label value."
#   type        = map(string)
#   default     = {}
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
#   value       = google_compute_forwarding_rule.default.ip_address
# }