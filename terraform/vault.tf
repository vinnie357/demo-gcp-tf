provider "vault" {
  # It is strongly recommended to configure this provider through the
  # environment variables described above, so that each user can have
  # separate credentials set in the environment.
  #
  # This will default to using $VAULT_ADDR
  # But can be set explicitly
  #address = "http://vault.mydomain.internal:30000"
  # This will default to using $VAULT_TOKEN
  # But can be set explicitly
  # token = "${var.vaultToken}"
}

data "vault_generic_secret" "bigip" {
  path="secret/bigip"
}
data "vault_generic_secret" "gcp_pub_key" {
  path="secret/gcp_pub_key"
}

data "vault_generic_secret" "gcp_creds_file" {
    path="secret/gcp_creds_file"
  
}

