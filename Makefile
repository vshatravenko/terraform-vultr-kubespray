.PHONY: docs

docs:
	terraform-docs markdown table \
		--header-from .header.md \
		--output-file README.md \
		--hide modules .

vars:
	terraform-docs tfvars hcl --output-file terraform.tfvars .

init:
	terraform init

apply:
	terraform apply

destroy:
	terraform destroy

