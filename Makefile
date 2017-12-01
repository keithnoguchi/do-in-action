# Droplet creation take a bit longer, 120 sec, before running test,
# due to the apt update && apt install python through user data.
DROPLET_WAIT_SECONDS ?= 120

# for recursive call
WAIT_SECONDS ?= 30
export WAIT_SECONDS

all: deploy

# Some terraform command aliases.
.PHONY: init plan show output apply
init plan show refresh output apply:
	terraform $@

.PHONY: deploy
deploy: init plan
	terraform apply -auto-approve
	$(MAKE) -C flips $@

.PHONY: test
test: deploy wait
	ansible-playbook tests/all.yml

.PHONY: test-all
test-all: test test-firewalls

.PHONY: test-firewalls
test-firewalls: test
	$(MAKE) -C firewalls test

.PHONY: wait
wait:
	sleep $(DROPLET_WAIT_SECONDS)

.PHONY: clean clean-all
clean: init
	$(MAKE) -C flips $@
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
clean-all: init
	$(MAKE) -C firewalls clean-all
	$(MAKE) clean
