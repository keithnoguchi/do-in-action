WAIT_SECONDS=30

all: plan deploy wait test

plan:
	terraform plan

deploy:
	terraform apply

wait:
	sleep ${WAIT_SECONDS}

test:
	ansible-playbook tests/http.yml
	ansible-playbook tests/tcp.yml
	ansible-playbook tests/udp.yml
	ansible-playbook tests/icmp.yml

clean:
	terraform destroy -force
	$(RM) *.tfstate*
	$(RM) tests/*.retry
