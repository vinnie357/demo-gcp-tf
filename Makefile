.PHONY: build test gcp run shell

export DIR = $(shell pwd)
export WORK_DIR = $(shell dirname ${DIR})

export CONTAINER_IMAGE = 'demo-gcp-tf'

build: buildContainer test

buildContainer:
	docker build -t ${CONTAINER_IMAGE} .

gcp: build test run

run:
	@#terraform init
	@echo "init"
	@echo "plan"
	@echo "apply"
	@docker run --rm -it \
	--volume ${DIR}:/workspace \
	-e GCP_SA_FILE=${GCP_SA_FILE} \
	-e GCP_PROJECT_ID=${GCP_PROJECT_ID} \
	-e GCP_REGION=${GCP_REGION} \
	-e VAULT_ADDR=${VAULT_ADDR} \
	-e VAULT_TOKEN=${VAULT_TOKEN} \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}.pub:/root/.ssh/${SSH_KEY_NAME}.pub:ro \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}:/root/.ssh/${SSH_KEY_NAME}:ro \
	-v ${WORK_DIR}/creds/gcp:/creds/gcp:ro \
	${CONTAINER_IMAGE} \
	bash -c "terraform init;terraform plan; terraform apply --auto-approve"

plan:
	@echo "tf plan ${WORK_DIR}"
	@docker run --rm -it \
	--volume ${DIR}:/workspace \
	-e GCP_SA_FILE=${GCP_SA_FILE} \
	-e GCP_PROJECT_ID=${GCP_PROJECT_ID} \
	-e GCP_REGION=${GCP_REGION} \
	-e VAULT_ADDR=${VAULT_ADDR} \
	-e VAULT_TOKEN=${VAULT_TOKEN} \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}.pub:/root/.ssh/${SSH_KEY_NAME}.pub:ro \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}:/root/.ssh/${SSH_KEY_NAME}:ro \
	-v ${WORK_DIR}/creds/gcp:/creds/gcp:ro \
	${CONTAINER_IMAGE} \
	bash -c "terraform init;terraform plan"


shell:
	@echo "tf shell ${WORK_DIR}"
	@docker run --rm -it \
	--volume ${DIR}:/workspace \
	-e GCP_SA_FILE=${GCP_SA_FILE} \
	-e GCP_PROJECT_ID=${GCP_PROJECT_ID} \
	-e GCP_REGION=${GCP_REGION} \
	-e VAULT_ADDR=${VAULT_ADDR} \
	-e VAULT_TOKEN=${VAULT_TOKEN} \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}.pub:/root/.ssh/${SSH_KEY_NAME}.pub:ro \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}:/root/.ssh/${SSH_KEY_NAME}:ro \
	-v ${WORK_DIR}/creds/gcp:/creds/gcp:ro \
	${CONTAINER_IMAGE} \

destroy:
	@#terraform destroy --auto-approve
	@echo "destroy"
	@docker run --rm -it \
	--volume ${DIR}:/workspace \
	-e GCP_SA_FILE=${GCP_SA_FILE} \
	-e GCP_PROJECT_ID=${GCP_PROJECT_ID} \
	-e GCP_REGION=${GCP_REGION} \
	-e VAULT_ADDR=${VAULT_ADDR} \
	-e VAULT_TOKEN=${VAULT_TOKEN} \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}.pub:/root/.ssh/${SSH_KEY_NAME}.pub:ro \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}:/root/.ssh/${SSH_KEY_NAME}:ro \
	-v ${WORK_DIR}/creds/gcp:/creds/gcp:ro \
	${CONTAINER_IMAGE} \
	bash -c "terraform destroy --auto-approve"


test: build test1 test2 test3 test4

test1:
	@echo "terraform test"
	@docker run --rm -it \
	--volume ${DIR}:/workspace \
	${CONTAINER_IMAGE} \
	bash -c "terraform --version"
test2:
	@#terraform init
	@echo "init"
	@docker run --rm -it \
	--volume ${DIR}:/workspace \
	-e GCP_SA_FILE=${GCP_SA_FILE} \
	-e GCP_PROJECT_ID=${GCP_PROJECT_ID} \
	-e GCP_REGION=${GCP_REGION} \
	-e VAULT_ADDR=${VAULT_ADDR} \
	-e VAULT_TOKEN=${VAULT_TOKEN} \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}.pub:/root/.ssh/${SSH_KEY_NAME}.pub:ro \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}:/root/.ssh/${SSH_KEY_NAME}:ro \
	-v ${WORK_DIR}/creds/gcp:/creds/gcp:ro \
	${CONTAINER_IMAGE} \
	bash -c "terraform init"
test3:
	@#terraform validate
	@echo "init"
	@echo "validate"
	@docker run --rm -it \
	--volume ${DIR}:/workspace \
	-e GCP_SA_FILE=${GCP_SA_FILE} \
	-e GCP_PROJECT_ID=${GCP_PROJECT_ID} \
	-e GCP_REGION=${GCP_REGION} \
	-e VAULT_ADDR=${VAULT_ADDR} \
	-e VAULT_TOKEN=${VAULT_TOKEN} \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}.pub:/root/.ssh/${SSH_KEY_NAME}.pub:ro \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}:/root/.ssh/${SSH_KEY_NAME}:ro \
	-v ${WORK_DIR}/creds/gcp:/creds/gcp:ro \
	${CONTAINER_IMAGE} \
	bash -c "terraform validate"
test4:
	@#terraform plan
	@echo "init"
	@echo "plan"
	@docker run --rm -it \
	--volume ${DIR}:/workspace \
	-e GCP_SA_FILE=${GCP_SA_FILE} \
	-e GCP_PROJECT_ID=${GCP_PROJECT_ID} \
	-e GCP_REGION=${GCP_REGION} \
	-e VAULT_ADDR=${VAULT_ADDR} \
	-e VAULT_TOKEN=${VAULT_TOKEN} \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}.pub:/root/.ssh/${SSH_KEY_NAME}.pub:ro \
	-v ${SSH_KEY_DIR}/${SSH_KEY_NAME}:/root/.ssh/${SSH_KEY_NAME}:ro \
	-v ${WORK_DIR}/creds/gcp:/creds/gcp:ro \
	${CONTAINER_IMAGE} \
	bash -c "terraform plan"
