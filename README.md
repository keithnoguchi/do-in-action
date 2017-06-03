# DO in Action!

Forming [DigitalOcean](http://digitalocean.com)
[droplets](http://www.digitalocean.com/products/compute/)
through [terraform](http://terraform.io).

- [Setup](#setup)
- [Run](#run)
- [References](#references)

## Setup

Sign up to [DigitalOcean](http://digitalocean.com) through
[cloud.digitalocean.com](https://cloud.digitalocean.com/registrations/new),
if you don't have DO account, and grab a [DO APIv2 token](http://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2)
and set it up for the [terraform](http://terraform.io) through
the `TA_VAR_DO_API_TOKEN` environment variable:

```sh
air$ export TF_VAR_DO_API_TOKEN=$(cat ~/.do/token.pem)
```

also, privide the SSH key in the setup section of the
[cloud.digitalocean.com](http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=12&ved=0ahUKEwjy1Z-Gs6LUAhWP2YMKHdz3ChUQFghUMAs&url=https%3A%2F%2Fwww.digitalocean.com%2Fcommunity%2Ftutorials%2Fhow-to-set-up-ssh-keys--2&usg=AFQjCNGf2nqGqjoCm0fCqIV3mR-djWG8qA)
and provide to [terraform](http://terraform.io) through the
the `TA_VAR_DO_FINGERPRINT` environment variable, to allow the
ssh connection to the droplets:

```sh
air$ export TF_VAR_DO_FINGERPRINT=$(ssh-keygen -E md5 -lf ~/.do/id_rsa.pub|awk '{print $2}'|sed 's/MD5://')
```

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
air$ ping -c3 $(terraform output server_flip)
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
[the droplet user data](main.tf), you can check the HTTP
reachability to the server, as below:

```sh
air$ curl http://$(terraform output server0_public_ipv4)
<h1>Hello world from server0</h1>
air$
```

and through floating IP:

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

Happy Hacking!
