WAIT_SECONDS ?= 30

all: deploy

# Some terraform command aliases.
.PHONY: init plan show output apply
init plan show output apply:
	terraform $@

.PHONY: deploy
deploy: init plan
	terraform apply -auto-approve

.PHONY: clean
clean: init
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
