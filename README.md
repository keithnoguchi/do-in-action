# doterra

Forming [droplets](https://www.digitalocean.com/products/compute/)
instances on [DigitalOcean](https://digitalocean.com)
through [terraform](https://terraform.io).

- [Setup](#setup)
- [Run](#run)
- [References](#references)

## Setup

Sign up through [cloud.digitalocean.com](https://cloud.digitalocean.com/registrations/new), if you don't have DO account, and grab a [DO APIv2 token](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2).

```sh
air$ export TF_VAR_DO_API_TOKEN=$(cat ~/.do/token.pem)
air$ export TF_VAR_DO_FINGERPRINT=$(ssh-keygen -E md5 -lf ~/.do/id_rsa.pub|awk '{print $2}'|sed 's/MD5://')
```

## Run

Here is the basic operations, plan, apply, show, destroy.
Please take a look at [main.tf](main.tf) for the resources.

### plan

```sh
air$ terraform plan
```

### apply

```sh
air$ terraform apply
```

Now you can ping to the public IPv4 address:

```sh
air$ ping -4 -c3 $(terraform output server0_public_ipv4)
PING 104.131.96.15 (104.131.96.15) 56(84) bytes of data.
64 bytes from 104.131.96.15: icmp_seq=1 ttl=56 time=81.9 ms
64 bytes from 104.131.96.15: icmp_seq=2 ttl=56 time=81.2 ms
64 bytes from 104.131.96.15: icmp_seq=3 ttl=56 time=78.3 ms

--- 104.131.96.15 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 78.335/80.504/81.943/1.578 ms
```
and IPv6, too:

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

And with the user data, we're listening on the port 80, as below:

From server0:

```sh
air$ curl http://$(tf output server0_public_ipv4)
<h1>Hello world from server0</h1>
```

server1:

```sh
air$ curl http://$(tf output server1_public_ipv4)
<h1>Hello world from server1</h1>
air$
```

and also, through floating IP:

```sh
air$ curl http://$(tf output server_flip)
<h1>Hello world from server0</h1>
```

### show

`terraform show` will give you the current state.

```sh
air$ terraform show
```

### output

`verraform output` will provide the output variables.

```sh
air$ terraform output
```

### destroy

`terraform destroy` will destroy the resources.

```sh
air$ terraform destroy
```

## References

Many thanks to [Yevgeniy (Jim) Brikman](http://www.ybrikman.com/) and
[Mitchell Anicas](https://twitter.com/thisismitch) for
sharing your terraform insights!

- [Terraform Up & Running](http://shop.oreilly.com/product/0636920061939.do)
- [How to use Terraform with DO](https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean)

Happy Hacking!
