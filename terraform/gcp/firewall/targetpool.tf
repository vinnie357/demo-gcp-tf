# ------------------------------------------------------------------------------
# CREATE TARGET POOL
# ------------------------------------------------------------------------------

resource "google_compute_target_pool" "default" {
  #provider         = google-beta
  #project          = var.project
  name             = "${var.projectPrefix}${var.name}-tp"
  region           = var.region
  session_affinity = var.session_affinity
  instances = "${google_compute_instance.vm_instance.*.self_link}"
  # you have to pass the array becuase of the count work around to make the monitor optional
  health_checks = google_compute_http_health_check.default.*.name
}

# fowarding rule
resource "google_compute_forwarding_rule" "default" {
  name                  = "${var.projectPrefix}firewall-forwarding-rule"
  port_range            = 443
  target                = google_compute_target_pool.default.self_link
}

# # instance group
# resource "google_compute_instance_group" "firewallext" {
#     name = "mydomain-firewall-instance-group"
#     zone = "us-east1-b"
#     instances = "${google_compute_instance.vm_instance.*.self_link}"
#     network = "${var.ext_vpc.name}"
#     named_port {
#         name = "app"
#         port = "443"
#     }
# }

# ------------------------------------------------------------------------------
# CREATE HEALTH CHECK
# ------------------------------------------------------------------------------

resource "google_compute_http_health_check" "default" {
  count = var.enable_health_check ? 1 : 0

  #provider            = google-beta
  #project             = var.project
  name                = "${var.projectPrefix}${var.name}-hc"
  request_path        = var.health_check_path
  port                = var.health_check_port
  check_interval_sec  = var.health_check_interval
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold
  timeout_sec         = var.health_check_timeout
}

# ------------------------------------------------------------------------------
# CREATE FIREWALL FOR THE HEALTH CHECKS
# ------------------------------------------------------------------------------

# # Health check firewall allows ingress tcp traffic from the health check IP addresses
resource "google_compute_firewall" "health_check" {
  count = var.enable_health_check ? 1 : 0

  #provider = google-beta
  #project  = var.network_project == null ? var.project : var.network_project
  name     = "${var.projectPrefix}${var.name}-hc-fw"
  network  = "${var.ext_vpc.name}"

  allow {
    protocol = "tcp"
    ports    = [var.health_check_port]
  }

  # These IP ranges are required for health checks
  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]

  # Target tags define the instances to which the rule applies
  target_tags = var.firewall_target_tags
}

#
resource "google_storage_bucket_object" "app-glb-1" {
name = "glb-1"
content = "${google_compute_forwarding_rule.default.ip_address}"
bucket = "${google_storage_bucket.bigip-ha.name}"
}