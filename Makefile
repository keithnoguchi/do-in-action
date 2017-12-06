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

.PHONY: bench-ipv4 bench-ipv4-private bench-ipv6
bench-ipv4: deploy
	ansible-playbook bench/ipv4.yml
bench-ipv4-private: deploy
	ansible-playbook bench/ipv4_private.yml
bench-ipv6: deploy
	ansible-playbook bench/ipv6.yml

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
