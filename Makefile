WAIT_SECONDS = 30

all: deploy

# Some terraform command aliases.
.PHONY: init plan show output apply
init plan show output apply:
	terraform $@

.PHONY: deploy
deploy: init plan
	terraform apply

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
	sleep $(WAIT_SECONDS)

.PHONY: clean
clean: init
	$(MAKE) -C firewalls clean
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
