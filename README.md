# awsform

Forming [droplets](https://www.digitalocean.com/products/compute/)
instances on [DigitalOcean](https://digitalocean.com)
through [terraform](https://terraform.io).

- [Setup](#setup)
- [Run](#run)
- [References](#references)

## Setup

Sign up through [cloud.digitalocean.com](https://cloud.digitalocean.com/registrations/new), if you don't have DO account, and grab a [DO APIv2 token](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2).

```sh
air$ export DO_TOKEN=$(cat ~/.do/token.pem)
air$ export DO_SSH_KEY=$(ssh-keygen -E md5 -lf ~/.do/id_key.pub|awk '{print $2}'|sed 's/MD5://')
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
air$ terraform apply -var do_token=$DO_TOKEN -var do_ssh_key=$DO_SSH_KEY
```

Now you can ping to the public IPv4 address:

```sh
air$ ping -c3 $(terraform output public_ipv4)
```

### show

```sh
air$ terraform show
```

### output

```sh
air$ terraform output
```

### destroy

```sh
air$ terraform destroy -var do_token=$DO_TOKEN -var do_ssh_key=$DO_SSH_KEY
```

## References

Many thanks to [Yevgeniy (Jim) Brikman](http://www.ybrikman.com/) for
sharing your terraform insights!

- [Terraform Up & Running](http://shop.oreilly.com/product/0636920061939.do)

Happy Hacking!
