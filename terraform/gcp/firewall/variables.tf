
variable "service_accounts" {
  type = "map"
}
# networks
variable "int_vpc" {
  
}
variable "ext_vpc" {
  
}
variable "mgmt_vpc" {
  
}
variable "mgmt_subnet" {
  
}
variable "int_subnet" {
  
}
variable "ext_subnet" {
  
}



# device
variable "projectPrefix" {
  description = "prefix for resources"
}
variable "buildSuffix" {
  description = "resource suffix"
}
variable "region" {
  description = "All resources will be launched in this region."
  default = "us-east1"
}
variable "name" {
  description = "device name"
  default = "afm"
}

variable "bigipImage" {
 description = " bigip gce image name"
 #default = "projects/f5-7626-networks-public/global/images/f5-bigip-15-0-1-1-0-0-3-byol-all-modules-2boot-loc-191118"
 default = "projects/f5-7626-networks-public/global/images/f5-bigip-15-1-0-4-0-0-6-payg-best-1gbps-200618231635"
}

variable "bigipMachineType" {
    description = "bigip gce machine type/size"
    #default = "n1-standard-4"
    default = "n1-standard-8"
}

variable "vm_count" {
    description = " number of devices"
    default = 2
}

variable "adminSrcAddr" {
  description = "admin source range in CIDR"

}

variable "gce_ssh_pub_key_file" {
    description = "path to public key for ssh access"
    default = "/root/.ssh/key.pub"
}

# bigip stuff

variable f5vm01mgmt { default = "10.0.10.3" }
variable f5vm01ext { default = "10.0.30.3" }
variable f5vm01ext_sec { default = "10.90.2.11" }
variable f5vm01int { default = "10.0.20.3"}
variable f5vm02mgmt { default = "10.0.10.4" }
variable f5vm02ext { default = "10.0.30.4" }
variable f5vm02ext_sec { default = "10.90.2.12" }
variable f5vm02int { default = "10.0.20.4"}
variable backend01ext { default = "10.0.20.101" }

variable adminAccountName { default = "admin" }
variable adminPass { 
    description = "bigip admin password"
    default = "admin"
 }
variable license1 { default = "" }
variable license2 { default = "" }
variable host1_name { default = "f5vm01" }
variable host2_name { default = "f5vm02" }
variable dns_server { default = "8.8.8.8" }
variable ntp_server { default = "0.us.pool.ntp.org" }
variable timezone { default = "UTC" }

variable libs_dir { default = "/config/cloud/gcp/node_modules" }
variable onboard_log { default = "/var/log/startup-script.log" }

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
variable DO_onboard_URL { default = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.9.0/f5-declarative-onboarding-1.9.0-1.noarch.rpm" }
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest 
variable AS3_URL { default = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.16.0/f5-appsvcs-3.16.0-6.noarch.rpm" }

# target pool settings
variable "enable_health_check" {
  description = "Flag to indicate if health check is enabled. If set to true, a firewall rule allowing health check probes is also created."
  type        = bool
  #default     = false
  default     = true
}

variable "health_check_port" {
  description = "The TCP port number for the HTTP health check request."
  type        = number
  #default     = 80
  default     = 443
}

variable "health_check_healthy_threshold" {
  description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes. The default value is 2."
  type        = number
  default     = 1
}

variable "health_check_unhealthy_threshold" {
  description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures. The default value is 2."
  type        = number
  default     = 2
}

variable "health_check_interval" {
  description = "How often (in seconds) to send a health check. Default is 5."
  type        = number
  default     = 1
}

variable "health_check_timeout" {
  description = "How long (in seconds) to wait before claiming failure. The default value is 5 seconds. It is invalid for 'health_check_timeout' to have greater value than 'health_check_interval'"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "The request path of the HTTP health check request. The default value is '/'."
  type        = string
  default     = "/"
}
variable "firewall_target_tags" {
  description = "List of target tags for the health check firewall rule."
  type        = list(string)
  default     = []
}
variable "session_affinity" {
  description = "The session affinity for the backends, e.g.: NONE, CLIENT_IP. Default is `NONE`."
  type        = string
  #default     = "NONE"
  default = "CLIENT_IP"
}