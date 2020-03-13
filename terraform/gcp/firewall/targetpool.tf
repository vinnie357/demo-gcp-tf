
#https://cloud.google.com/load-balancing/docs/network
#https://cloud.google.com/load-balancing/docs/tcp/setting-up-tcp
# ------------------------------------------------------------------------------
# fowarding rule
# ------------------------------------------------------------------------------

resource "google_compute_global_forwarding_rule" "default_tcp" {
  name       = "${var.projectPrefix}global-firewall-forwarding-rule${var.buildSuffix}"
  target     = "${google_compute_target_tcp_proxy.default.self_link}"
  ip_protocol = "TCP"
  ip_version = "IPV4"
  port_range = "443"
  load_balancing_scheme = "EXTERNAL"
  description = "demo app global tcp forward rule"
}

# resource "google_compute_forwarding_rule" "default_tcp" {
#   name                  = "${var.projectPrefix}firewall-forwarding-rule${var.buildSuffix}"
#   ip_protocol    = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   target       = "${google_compute_target_tcp_proxy.default.self_link}"
# }
# ------------------------------------------------------------------------------
# TCP PROXY
# ------------------------------------------------------------------------------
resource "google_compute_target_tcp_proxy" "default" {
  name            = "${var.projectPrefix}test-proxy${var.buildSuffix}"
  backend_service = google_compute_backend_service.default.self_link
}
# ------------------------------------------------------------------------------
# instance group
# ------------------------------------------------------------------------------

resource "google_compute_instance_group" "firewallext" {
    name = "${var.projectPrefix}firewall-instance-group${var.buildSuffix}"
    instances = "${google_compute_instance.vm_instance.*.self_link}"
    network = "${var.ext_vpc.self_link}"
    named_port {
            name = "app"
            port = "443"
        }
    named_port {
            name = "monitor"
            port = "80"
        }
}
# ------------------------------------------------------------------------------
# BACKEND
# ------------------------------------------------------------------------------
resource "google_compute_backend_service" "default" {
  name        = "${var.projectPrefix}backend-service${var.buildSuffix}"
  protocol    = "TCP"
  timeout_sec = 5
  # gcp only supports 1 health check 
  #health_checks = [ google_compute_health_check.default_tcp.self_link, google_compute_health_check.default_http.self_link ]
  health_checks = [ google_compute_health_check.default_https.self_link ]
  backend  {
      group  = google_compute_instance_group.firewallext.self_link
  }
  port_name = "app"
}

# ------------------------------------------------------------------------------
# CREATE HEALTH CHECKS
# ------------------------------------------------------------------------------
# tcp
# resource "google_compute_health_check" "default_tcp" {
#   name        = "${var.projectPrefix}tcp-health-check${var.buildSuffix}"
#   description = "Health check via tcp"

#   timeout_sec         = 1
#   check_interval_sec  = 1
#   healthy_threshold   = 4
#   unhealthy_threshold = 5

#   tcp_health_check {
#     port_name          = "app"
#     port_specification = "USE_NAMED_PORT"
#     request            = "ARE YOU HEALTHY?"
#     proxy_header       = "NONE"
#     response           = "I AM HEALTHY"
#   }
# }
# ssl
resource "google_compute_health_check" "default_ssl" {
  name        = "${var.projectPrefix}ssl-health-check${var.buildSuffix}"
  description = "Health check via ssl"

  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 4
  unhealthy_threshold = 5

  ssl_health_check {
    port_name          = "app"
    port_specification = "USE_NAMED_PORT"
    request            = "ARE YOU HEALTHY?"
    proxy_header       = "NONE"
    response           = "I AM HEALTHY"
  }
}
# http
resource "google_compute_health_check" "default_http" {
  name               = "${var.projectPrefix}http-health-check${var.buildSuffix}"
  description = "Health check via http"
  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 4
  unhealthy_threshold = 5

  http_health_check {
    port_name          = "app"
    port_specification = "USE_NAMED_PORT"
    request_path       = "/"
    proxy_header       = "NONE"
    response           = "System is online."
  }
}
# https
resource "google_compute_health_check" "default_https" {
  name        = "${var.projectPrefix}https-health-check${var.buildSuffix}"
  description = "Health check via https"

  timeout_sec         = 1
  check_interval_sec  = 1
  healthy_threshold   = 4
  unhealthy_threshold = 5

  https_health_check {
    port_name          = "app"
    port_specification = "USE_NAMED_PORT"
    host               = "app.example.com"
    request_path       = "/health"
    proxy_header       = "NONE"
    response           = "System is online."
  }
}
# ------------------------------------------------------------------------------
# CREATE TARGET POOL
# ------------------------------------------------------------------------------

# resource "google_compute_target_pool" "default" {
#   #provider         = google-beta
#   #project          = var.project
#   name             = "${var.projectPrefix}${var.name}-tp${var.buildSuffix}"
#   region           = var.region
#   session_affinity = var.session_affinity
#   instances = "${google_compute_instance.vm_instance.*.self_link}"
#   # you have to pass the array becuase of the count work around to make the monitor optional
#   health_checks = google_compute_http_health_check.default.*.name
# }

# # fowarding rule
# resource "google_compute_forwarding_rule" "default" {
#   name                  = "${var.projectPrefix}firewall-forwarding-rule${var.buildSuffix}"
#   port_range            = 443
#   target                = google_compute_target_pool.default.self_link
# }


# ------------------------------------------------------------------------------
# CREATE HEALTH CHECK
# ------------------------------------------------------------------------------

# resource "google_compute_http_health_check" "default" {
#   count = var.enable_health_check ? 1 : 0

#   #provider            = google-beta
#   #project             = var.project
#   name                = "${var.projectPrefix}${var.name}-hc${var.buildSuffix}"
#   request_path        = var.health_check_path
#   port                = var.health_check_port
#   check_interval_sec  = var.health_check_interval
#   healthy_threshold   = var.health_check_healthy_threshold
#   unhealthy_threshold = var.health_check_unhealthy_threshold
#   timeout_sec         = var.health_check_timeout
# }

# ------------------------------------------------------------------------------
# CREATE FIREWALL FOR THE HEALTH CHECKS
# ------------------------------------------------------------------------------
#https://cloud.google.com/load-balancing/docs/health-checks
# # Health check firewall allows ingress tcp traffic from the health check IP addresses
resource "google_compute_firewall" "health_check" {
  count = var.enable_health_check ? 1 : 0

  #provider = google-beta
  #project  = var.network_project == null ? var.project : var.network_project
  name     = "${var.projectPrefix}${var.name}-hc-fw${var.buildSuffix}"
  network  = "${var.ext_vpc.name}"

  allow {
    protocol = "tcp"
    ports    = [var.health_check_port]
  }

  # These IP ranges are required for  LEGACY health checks
  #source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]
  #these IP ranges are rquired for CURRENT health checks
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

  # Target tags define the instances to which the rule applies
  #target_tags = var.firewall_target_tags
  target_tags = ["allow-health-checks"]
  #--target-tags tcp-lb \
}

#
resource "google_storage_bucket_object" "app-glb-1" {
name = "glb-1"
content = "${google_compute_global_forwarding_rule.default_tcp.ip_address}"
bucket = "${google_storage_bucket.bigip-ha.name}"
}