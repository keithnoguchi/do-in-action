WAIT_SECONDS = 30

all: deploy

.PHONY: deploy
deploy: plan
	terraform apply

# Some terraform command aliases.
.PHONY: plan show output
plan:
	terraform $@
show: deploy
	terraform $@
output: deploy
	terraform $@

.PHONY: wait
wait:
	sleep $(WAIT_SECONDS)

.PHONY: test
test: deploy wait
	ansible-playbook tests/all.yml

.PHONY: test-firewalls
test-firewalls: test
	$(MAKE) -C firewalls test

.PHONY: test-all
test-all: test test-firewalls

.PHONY: clean
clean:
	$(MAKE) -C firewalls clean
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
