WAIT_SECONDS ?= 30

# for recursive call
export WAIT_SECONDS

all: deploy

# Some terraform command aliases.
.PHONY: init plan show output apply
init plan show output apply:
	terraform $@

.PHONY: deploy
deploy: init plan
	terraform apply -auto-approve

.PHONY: clean clean-all
clean: init
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) *.log
clean-all: init
	$(MAKE) clean
