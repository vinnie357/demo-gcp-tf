#====================#
#  vault             #
#====================#
variable "vaultToken" {
    description = "token for vault access"
    default = "root"
}

#====================#
#  mydomain          #
#====================#
variable "projectPrefix" {
    description = "prefix for resources"
    default = "mydomain-"
}


#====================#
# GCP   connection   #
#====================#
variable "GCP_SA_FILE_NAME" {
  description = "creds file name"
  default = "mycredsfile"
}

variable "GCP_PROJECT_ID" {
  description = "project ID"
  default = "myprojectid-1234"
}

variable "GCP_SSH_KEY_PATH" {
    description = " path to ssh public key for vms"
    default = "/root/.ssh/mykey.pub"
  
}

variable "gcp_service_accounts" {
  type = "map"
  default = {
      storage = "default-compute@developer.gserviceaccount.com"
      compute = "default-compute@developer.gserviceaccount.com"
    }
}

#====================#
# admin   connection #
#====================#

variable "adminSrcAddr" {
  description = "admin source range in CIDR x.x.x.x/24"
  default = "192.168.2.1/32"
}

variable "adminAccount" {
  description = "admin account name"
  default ="admin"
}
variable "adminPass" {
  description = "admin account password"
  default = "admin"
}