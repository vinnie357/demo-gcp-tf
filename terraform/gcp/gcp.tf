# https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform
provider "google" {
  #credentials = "${file("../${path.root}/creds/gcp/${var.GCP_SA_FILE_NAME}.json")}"
  credentials = "${var.GCP_CREDS_FILE}"
  project     = "${var.GCP_PROJECT_ID}"
  region      = "${var.GCP_REGION}"
  zone        = "${var.GCP_ZONE}"
}

# networks
# vpc
resource "google_compute_network" "vpc_network_mgmt" {
  name                    = "${var.projectPrefix}terraform-network-mgmt${var.buildSuffix}"
  auto_create_subnetworks = "false"
  routing_mode = "REGIONAL"
}
resource "google_compute_subnetwork" "vpc_network_mgmt_sub" {
  name          = "${var.projectPrefix}mgmt-sub${var.buildSuffix}"
  ip_cidr_range = "10.0.10.0/24"
  region        = "${var.GCP_REGION}"
  network       = "${google_compute_network.vpc_network_mgmt.self_link}"

}
resource "google_compute_network" "vpc_network_int" {
  name                    = "${var.projectPrefix}terraform-network-int${var.buildSuffix}"
  auto_create_subnetworks = "false"
  routing_mode = "REGIONAL"
}
resource "google_compute_subnetwork" "vpc_network_int_sub" {
  name          = "${var.projectPrefix}int-sub${var.buildSuffix}"
  ip_cidr_range = "10.0.20.0/24"
  region        = "${var.GCP_REGION}"
  network       = "${google_compute_network.vpc_network_int.self_link}"

}
resource "google_compute_network" "vpc_network_ext" {
  name                    = "${var.projectPrefix}terraform-network-ext${var.buildSuffix}"
  auto_create_subnetworks = "false"
  routing_mode = "REGIONAL"
}
resource "google_compute_subnetwork" "vpc_network_ext_sub" {
  name          = "${var.projectPrefix}ext-sub${var.buildSuffix}"
  ip_cidr_range = "10.0.30.0/24"
  region        = "${var.GCP_REGION}"
  network       = "${google_compute_network.vpc_network_ext.self_link}"

}
resource "google_compute_firewall" "default-allow-internal-mgmt" {
  name    = "${var.projectPrefix}default-allow-internal-mgmt-firewall${var.buildSuffix}"
  network = "${google_compute_network.vpc_network_mgmt.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = ["10.0.10.0/24"]
}
resource "google_compute_firewall" "default-allow-internal-ext" {
  name    = "${var.projectPrefix}default-allow-internal-ext-firewall${var.buildSuffix}"
  network = "${google_compute_network.vpc_network_ext.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = ["10.0.30.0/24"]
}
resource "google_compute_firewall" "default-allow-internal-int" {
  name    = "${var.projectPrefix}default-allow-internal-int-firewall${var.buildSuffix}"
  network = "${google_compute_network.vpc_network_int.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  priority = "65534"

  source_ranges = ["10.0.20.0/24"]
}

# }
# workloads

# module "application" {
#   source   = "./application"
#   #======================#
#   # application settings #
#   #======================#
#   name = "${var.appName}"
#   gce_ssh_pub_key_file = "${var.sshKeyPath}"
#   adminAccountName = "${var.adminAccount}"
#   int_vpc = "${google_compute_network.vpc_network_int}"
#   int_subnet = "${google_compute_subnetwork.vpc_network_int_sub}"
#   projectPrefix = "${var.projectPrefix}"
#   buildSuffix = "${var.buildSuffix}"
#   region = "${var.GCP_REGION}"
# }

module "firewall" {
  source   = "./firewall"
  #====================#
  # firewall settings  #
  #====================#
  gce_ssh_pub_key_file = "${var.sshKeyPath}"
  adminSrcAddr = "${var.adminSrcAddr}"
  adminPass = "${var.adminPass}"
  adminAccountName = "${var.adminAccount}"
  mgmt_vpc = "${google_compute_network.vpc_network_mgmt}"
  int_vpc = "${google_compute_network.vpc_network_int}"
  ext_vpc = "${google_compute_network.vpc_network_ext}"
  mgmt_subnet = "${google_compute_subnetwork.vpc_network_mgmt_sub}"
  int_subnet = "${google_compute_subnetwork.vpc_network_int_sub}"
  ext_subnet = "${google_compute_subnetwork.vpc_network_ext_sub}"
  projectPrefix = "${var.projectPrefix}"
  buildSuffix = "-${var.buildSuffix}"
  service_accounts = "${var.service_accounts}"
  region = "${var.GCP_REGION}"
}


# module "waf" {
#   source   = "./waf"
#   #====================#
#   # waf settings       #
#   #====================#
#   gce_ssh_pub_key_file = "${var.sshKeyPath}"
#   adminSrcAddr = "${var.adminSrcAddr}"
#   adminPass = "${var.adminPass}"
#   adminAccountName = "${var.adminAccount}"
#   mgmt_vpc = "${google_compute_network.vpc_network_mgmt}"
#   int_vpc = "${google_compute_network.vpc_network_int}"
#   ext_vpc = "${google_compute_network.vpc_network_ext}"
#   mgmt_subnet = "${google_compute_subnetwork.vpc_network_mgmt_sub}"
#   int_subnet = "${google_compute_subnetwork.vpc_network_int_sub}"
#   ext_subnet = "${google_compute_subnetwork.vpc_network_ext_sub}"
#   projectPrefix = "${var.projectPrefix}"
# }