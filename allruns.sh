#!/bin/bash
# requires jq
# assumes secrets vault kv2 api and your vault is unsealed
## set vars
# vault
echo -n "Enter your vault hostname and press [ENTER]: "
read vaultHost
echo -n "Enter your vault token and press [ENTER]: "
read -s vaultToken
echo ""
export VAULT_ADDR=${vaultHost}
export VAULT_TOKEN=$(echo "${vaultToken}")

echo "env vars done"