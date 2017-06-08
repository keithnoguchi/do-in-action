WAIT_SECONDS = 30

all: deploy

.PHONY: deploy
deploy: plan
	terraform apply

.PHONY: test
test: deploy wait
	ansible-playbook tests/all.yml

.PHONY: test-all
test-all: test test-firewalls

.PHONY: test-firewalls
test-firewalls: test
	$(MAKE) -C firewalls test

# Some terraform command aliases.
.PHONY: plan show output
plan show output:
	terraform $@

.PHONY: wait
wait:
	sleep $(WAIT_SECONDS)

.PHONY: clean
clean:
	$(MAKE) -C firewalls clean
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
