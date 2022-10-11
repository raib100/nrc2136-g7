# A Self-Documenting Makefile: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
SHELL = /bin/bash
OS = $(shell uname | tr A-Z a-z)

.PHONY: create-infrastructure
create-infrastructure: ## Create infrastructure
	(cd infrastructure/; terraform init; terraform apply -auto-approve)
	chmod 600 infrastructure/keys/nrc2136-g7.pem

.PHONY: destroy-infrastructure
destroy-infrastructure: ## Destroy infrastructure
	(cd infrastructure/; terraform destroy -auto-approve)
	rm -rf infrastructure/keys/nrc2136-g7.pem

.PHONY: launch_docker_app
launch_docker_app:
	flask run -h 0.0.0.0