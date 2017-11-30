# DigitalOcean in Action!

Forming [DigitalOcean](http://digitalocean.com)
[droplets](http://www.digitalocean.com/products/compute/)
through [terraform](http://terraform.io).

- [Setup](#setup)
- [Run](#run)
- [References](#references)
- [Casts](#casts)

Install [terraform](http://terraform.io) and [ansible](http://ansible.com)
on your favorite laptop/desktop and enjoy having DO in action!

Note that, since [DO Cloud Firewalls](https://do.co/cloud-firewalls) support
has been just
[merged into master](https://github.com/terraform-providers/terraform-provider-digitalocean/pull/1)
recently, you either grab the latest DO provider release,
[0.1.0](https://github.com/terraform-providers/terraform-provider-digitalocean/blob/master/CHANGELOG.md#010-june-19-2017),
or git clone by yourself, if you're adventurous.

Here is a part of
[ansible playbook](https://github.com/keinohguchi/arch-on-air/blob/master/guest.yml#L33-L48)
I wrote for [arch-on-air](https://github.com/keinohguchi/arch-on-air)
to `git clone` and install the latest [terraform](http://terraform.io)
and [ansible](http://ansible.com).  As both are under really active development,
use it on your own risk with hacker's mind. :)

## Setup

Sign in or sign up to [DigitalOcean](http://digitalocean.com) through
[cloud.digitalocean.com](https://cloud.digitalocean.com/registrations/new)
and grab a [DO APIv2 token](http://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2).
And then, set the API token for the [terraform](http://terraform.io)
by defining `TA_VAR_DO_API_TOKEN` environment variable as below:

```sh
air$ export TF_VAR_DO_API_TOKEN=$(cat ~/.do/token.pem)
```

also, setup the SSH key in the setup section of the
[cloud.digitalocean.com](http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=12&ved=0ahUKEwjy1Z-Gs6LUAhWP2YMKHdz3ChUQFghUMAs&url=https%3A%2F%2Fwww.digitalocean.com%2Fcommunity%2Ftutorials%2Fhow-to-set-up-ssh-keys--2&usg=AFQjCNGf2nqGqjoCm0fCqIV3mR-djWG8qA)
and give it to [terraform](http://terraform.io) through
`TA_VAR_DO_FINGERPRINT` environment variable, so that you can
ssh into those droplets:

```sh
air$ export TF_VAR_DO_FINGERPRINT=$(ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub|awk '{print $2}'|sed 's/MD5://')
```

That's it!  Now, let's roll!

## Run

As mentioned before, all the droplets are formed through
the [terraform](http://terraform.io), as you can see it
in [main.tf](main.tf) file.  To make the operation
straightforward, however, I've wrote a simple [Makefile](Makefile).

- [Plan](#plan)
- [Deploy](#deploy)
- [Test](#test)
- [Cleanup](#cleanup)

### Plan

[terraform](http://terraform.io) has a way to dry run the
actual actions through `terraform plan`.  There is a one-to-one
[Makefile](Makefile) target, called, `plan`:

```sh
air$ make plan
```

### Deploy

[Makefile](Makefile) deploy target is, as you can guess,
just a wrapper to the `terraform apply`:

```sh
air$ make deploy
```

this will droplets in the cloud.  Through the use
of [terraform output variables](outputs.tf), you can check the
IP reachability to one of the droplets as below:

IPv4:

```sh
air$ ping -4 -c3 $(terraform output server0_public_ipv4)
PING 104.131.96.15 (104.131.96.15) 56(84) bytes of data.
64 bytes from 104.131.96.15: icmp_seq=1 ttl=56 time=81.9 ms
64 bytes from 104.131.96.15: icmp_seq=2 ttl=56 time=81.2 ms
64 bytes from 104.131.96.15: icmp_seq=3 ttl=56 time=78.3 ms

--- 104.131.96.15 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 78.335/80.504/81.943/1.578 ms
air$
```
IPv6:

```sh
air$ ping -6 -c3 $(terraform output server0_public_ipv6)
PING 2604:a880:0800:0010:0000:0000:319e:1001(2604:a880:800:10::319e:1001) 56 data bytes
64 bytes from 2604:a880:800:10::319e:1001: icmp_seq=1 ttl=49 time=81.4 ms
64 bytes from 2604:a880:800:10::319e:1001: icmp_seq=2 ttl=49 time=81.4 ms
64 bytes from 2604:a880:800:10::319e:1001: icmp_seq=3 ttl=49 time=79.5 ms

--- 2604:a880:0800:0010:0000:0000:319e:1001 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 79.521/80.806/81.467/0.908 ms
air$
```

and to the floating IP:

```sh
air$ ping -c3 $(cd flips && terraform output server_flip)
PING 45.55.97.179 (45.55.97.179) 56(84) bytes of data.
64 bytes from 45.55.97.179: icmp_seq=1 ttl=56 time=99.2 ms
64 bytes from 45.55.97.179: icmp_seq=2 ttl=56 time=97.6 ms
64 bytes from 45.55.97.179: icmp_seq=3 ttl=56 time=98.5 ms

--- 45.55.97.179 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 97.690/98.508/99.278/0.649 ms
air$
```

And, as we're running the simple HTTP server through
[the droplet user data](http://www.digitalocean.com/community/tutorials/an-introduction-to-droplet-metadata), you can check the HTTP
reachability to the server, as below:

```sh
air$ curl http://$(terraform output server0_public_ipv4)
<h1>Hello world from server0</h1>
air$
```

and through the floating IP:

```sh
air$ curl http://$(terraform output server_flip)
<h1>Hello world from server0</h1>
air$
```

### Test

Of course, you need a test to check those droplets.  I use
[ansible](http://ansible.com) to drive all those tests by
[dynamically](http://docs.ansible.com/ansible/intro_dynamic_inventory.html)
retrieving the variables, IP addresses, etc., through the
[inventory.py](inventory.py).  All you need to do is just
call `make test`, which deploy droplets, if it's not there,
and run all the ansible test playbooks:

```sh
air$ make test | tail -4

PLAY RECAP *********************************************************************
45.55.207.205              : ok=32   changed=0    unreachable=0    failed=0

air$
```

#### Test matrix

Here is the test matrix covered by `make test-all`:

| Firewall type | [Non firewall](main.tf) | [Inbound deny-all](firewalls/server/000-deny-all/main.tf) | [Inbound allow-all](firewalls/server/999-allow-all/main.tf) | [Outbound deny-all](firewalls/client/000-deny-all/main.tf) | [Outbound allow-all](firewalls/client/999-allow-all/main.tf) | [In/Out-bound deny-all](firewalls/both/000-deny-all/main.tf) | [In/Out-bound allow-all](firewalls/both/999-allow-all/main.tf) |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| ICMP | [PASS](tests/icmp.yml) | [PASS](firewalls/server/000-deny-all/tests/icmp.yml) | [PASS](firewalls/server/999-allow-all/tests/icmp.yml) | [PASS](firewalls/client/000-deny-all/tests/icmp.yml) | [PASS](firewalls/client/999-allow-all/tests/icmp.yml) | [PASS](firewalls/both/000-deny-all/tests/icmp.yml) | [PASS](firewalls/both/999-allow-all/tests/icmp.yml) |
| ICMP port unreach | [PASS](tests/icmp_port_unreach.yml) | [PASS](firewalls/server/000-deny-all/tests/icmp_port_unreach.yml) | [PASS](firewalls/server/999-allow-all/tests/icmp_port_unreach.yml) | [PASS](firewalls/client/000-deny-all/tests/icmp_port_unreach.yml) | [PASS](firewalls/client/999-allow-all/tests/icmp_port_unreach.yml) | [PASS](firewalls/both/000-deny-all/tests/icmp_port_unreach.yml) | [PASS](firewalls/both/999-allow-all/tests/icmp_port_unreach.yml) |
| HTTP | [PASS](tests/http.yml) | [PASS](firewalls/server/000-deny-all/tests/http.yml) | [PASS](firewalls/server/999-allow-all/tests/http.yml) | [PASS](firewalls/client/000-deny-all/tests/http.yml) | [PASS](firewalls/client/999-allow-all/tests/http.yml) | [PASS](firewalls/both/000-deny-all/tests/http.yml) | [PASS](firewalls/both/999-allow-all/tests/http.yml) |
| TCP | [PASS](tests/tcp.yml) | [PASS](firewalls/server/000-deny-all/tests/tcp.yml) | [PASS](firewalls/server/999-allow-all/tests/tcp.yml) | [PASS](firewalls/client/000-deny-all/tests/tcp.yml) | [PASS](firewalls/client/999-allow-all/tests/tcp.yml) | [PASS](firewalls/both/000-deny-all/tests/tcp.yml) | [PASS](firewalls/both/999-allow-all/tests/tcp.yml) |
| UDP | [PASS](tests/udp.yml) | [PASS](firewalls/server/000-deny-all/tests/udp.yml) | [PASS](firewalls/server/999-allow-all/tests/udp.yml) | [PASS](firewalls/client/000-deny-all/tests/udp.yml) | [PASS](firewalls/client/999-allow-all/tests/udp.yml) | [PASS](firewalls/both/000-deny-all/tests/udp.yml) | [PASS](firewalls/both/999-allow-all/tests/udp.yml) |
| FTP | [PASS](tests/ftp.yml) | [PASS](firewalls/server/000-deny-all/tests/ftp.yml) | [PASS](firewalls/server/999-allow-all/tests/ftp.yml) | [PASS](firewalls/client/000-deny-all/tests/ftp.yml) | [PASS](firewalls/client/999-allow-all/tests/ftp.yml) | [PASS](firewalls/both/000-deny-all/tests/ftp.yml) | [PASS](firewalls/both/999-allow-all/tests/ftp.yml) |

Note that all those Ansible test playbooks covers four different
IP reachability, public IPv4, private IPv4, public IPv6, and
floating IPv4, respectively.

And also, you can run those tests indivisually through the standard
ansible command.  For example, following command runs HTTP test for
non firewalls setup.

```sh
air$ ansible-playbook tests/http.yml
```

#### Test in the entire DO

Here is the simple shell script to run the test in the entire DO!

```sh
air$ for region in ams2 ams3 blr1 fra1 lon1 nyc1 nyc2 nyc3 sfo1 sfo2 sgp1 tor1
do
	# Cleanup the environment before the test.
	if ! make test-all TF_VAR_DO_REGION=$region
	then
		break
	fi
done
```

### Cleanup

Of course, we can destroy all those instances through `make clean`,
which is just calling `terraform destroy` in addition to cleaning
up the terraform state files:


```sh
air$ make clean
```

## References

Many thanks to [Yevgeniy (Jim) Brikman](http://www.ybrikman.com/) and
[Mitchell Anicas](http://twitter.com/thisismitch) for
sharing your [terraform](http://terraform.io) insights!

- [Terraform Up & Running](http://shop.oreilly.com/product/0636920061939.do)
- [How to use Terraform with DO](http://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean)

## Casts

I've recorded the [asciinema](https://asciinema.org) cast for the droplet creation part.
I'll upload it to the official site soon, but in a meanwhile, you can watch it with:

```sh
$ git clone https://github.com/keinohguchi/do-in-action
$ cd do-in-action
$ asciinema play ./casts/droplet.json
```

Happy Hacking!
