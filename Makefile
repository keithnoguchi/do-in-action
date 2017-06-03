WAIT_SECONDS=30

all: deploy

.PHONY: plan
plan:
	terraform plan

.PHONY: deploy
deploy: plan
	terraform apply

.PHONY: wait
wait:
	sleep ${WAIT_SECONDS}

.PHONY: test
test: deploy wait
	ansible-playbook tests/all.yml

.PHONY: clean
clean:
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
	$(RM) *.log
