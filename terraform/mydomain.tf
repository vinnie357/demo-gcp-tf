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
    sshKeyPath = "${var.GCP_SSH_KEY_PATH}"
    adminSrcAddr = "${var.adminSrcAddr}"
    adminAccount = "${data.vault_generic_secret.bigip.data["admin"]}"
    adminPass = "${data.vault_generic_secret.bigip.data["pass"]}"
    projectPrefix = "${var.projectPrefix}"
    service_accounts = "${var.gcp_service_accounts}"
}
