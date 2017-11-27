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

.PHONY: test
test: deploy wait
	ansible-playbook tests/all.yml

.PHONY: test-all
test-all: clean test test-firewalls

.PHONY: test-firewalls
test-firewalls: test
	$(MAKE) -C firewalls test

.PHONY: wait
wait:
	sleep $(WAIT_SECONDS)

.PHONY: clean clean-all
clean: init
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
clean-all: init
	$(MAKE) -C firewalls clean-all
	$(MAKE) clean
