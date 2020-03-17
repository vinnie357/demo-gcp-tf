#===============================================================================
# Create lab infra
#===============================================================================

# Deploy GCP Module
module "gcp" {
  source   = "./gcp"
#   AllowedIPs = "${var.AllowedIPs}"
#   key_path = "${var.key_path}"
    GCP_CREDS_FILE = "${data.vault_generic_secret.gcp_creds_file.data_json}"
    GCP_SA_FILE_NAME = "${var.GCP_SA_FILE_NAME}"
    GCP_PROJECT_ID = "${data.vault_generic_secret.gcp_creds_file.data["project_id"]}"
    sshKeyPath = "${data.vault_generic_secret.gcp_pub_key.data["key"]}"
    adminSrcAddr = "${var.adminSrcAddr}"
    adminAccount = "${data.vault_generic_secret.bigip.data["admin"]}"
    adminPass = "${data.vault_generic_secret.bigip.data["pass"]}"
    projectPrefix = "${var.projectPrefix}"
    buildSuffix = "-${random_pet.buildSuffix.id}"
    service_accounts = "${var.gcp_service_accounts}"
}
resource "random_pet" "buildSuffix" {
  keepers = {
    # Generate a new pet name each time we switch to a new AMI id
    #ami_id = "${var.ami_id}"
    prefix = "${var.projectPrefix}"
  }
  #length = ""
  #prefix = "${var.projectPrefix}"
  separator = "-"
}