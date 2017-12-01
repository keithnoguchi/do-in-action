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

.PHONY: test test-all test-firewalls
test: deploy wait
	ansible-playbook tests/all.yml
test-all: test test-firewalls
test-firewalls:
	$(MAKE) -C firewalls test

.PHONY: wait
wait:
	sleep $(DROPLET_WAIT_SECONDS)

.PHONY: clean clean-all clean-firewalls
clean: init
	$(MAKE) -C flips $@
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
clean-all: clean-firewalls clean
clean-firewalls:
	$(MAKE) -C firewalls clean-all
