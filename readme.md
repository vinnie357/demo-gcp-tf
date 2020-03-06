# Demo [GCP](https://cloud.google.com/) [BIG-IP](https://www.f5.com/products/big-ip-services/virtual-editions) deployment with [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) app.
Makes use of:
- docker
  - [docker](https://www.docker.com/)
- HashiCorp
  -  [Terraform](https://www.terraform.io/)
  -  [Vault](https://www.vaultproject.io/)
-  F5
   -  [Declarative Onboarding](https://clouddocs.f5.com/products/extensions/f5-declarative-onboarding/latest/)
   -  [Application Services 3 Extension](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/)
   -  [Telemetry Streaming](https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/latest/)
   -  [Cloud Failover Extension](https://clouddocs.f5.com/products/extensions/f5-cloud-failover/latest/)
-  GNU
   -  [GNU Make](https://www.gnu.org/software/make/)
## Requirements
- docker
- make
- bash one of:
  - linux
  - mac
  - windows [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
    - docker setup for wsl [windows docker desktop setup](https://nickjanetakis.com/blog/setting-up-docker-for-windows-and-wsl-to-work-flawlessly)
- Vault Instance
  - kv secrets v2 api enabled
### Setup
- set your enviroment vars and save them to vault

```bash
$. env_vars_helper.sh
```
- set your [admin source range](https://www.ipchicken.com/) in an file.auto.tfvars
- set your path to public ssh key for machine access
- gcp service account file name if not using vault .json is assumed.
```hcl
    admin source address
    adminSrcAddr="192.168.2.1/32"
    # path to public key for instances
    GCP_SSH_KEY_PATH="/root/.ssh/machinekey.pub"
    # file name of gcp service account creds for local file access
    GCP_SA_FILE_NAME="org-gcs-project-id"
```

### Run
```bash
make gcp
```

### Destroy
```bash
make destroy
```


### issues
-----------
do hostname lengths
```bash
  "errors": [
    "01070903:3: Constraint 'hostname must contain less than 65 characters' failed for '/Common/system'",
    "01070903:3: Constraint 'hostname must contain less than 65 characters' failed for '/Common/system'"
  ]
```