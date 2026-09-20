# Convenience targets. Usage: make plan DIR=05-eks
DIR ?= 01-basics/02-ec2-keypair-sg

.PHONY: fmt validate init plan apply destroy clean workspaces

fmt:        ## Format every .tf file in the repo
	terraform fmt -recursive .

validate:   ## Validate a single stack
	cd $(DIR) && terraform init -backend=false && terraform validate

init:
	cd $(DIR) && terraform init

plan:
	cd $(DIR) && terraform plan

apply:
	cd $(DIR) && terraform apply

destroy:
	cd $(DIR) && terraform destroy

workspaces:
	cd 04-workspaces && terraform workspace list

clean:
	find . -type d -name ".terraform" -prune -exec rm -rf {} +
	find . -type f -name "*.tfplan" -delete
