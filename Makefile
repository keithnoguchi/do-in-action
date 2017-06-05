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

.PHONY: clean
clean:
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
