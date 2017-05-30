variable "do_token" {}
variable "do_ssh_key" {}

output "public_ipv4" {
  value = "${digitalocean_droplet.web.ipv4_address}"
}

output "public_ipv6" {
  value = "${digitalocean_droplet.web.ipv6_address}"
}

# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.do_token}"
}

# https://www.terraform.io/docs/providers/do/r/droplet.html
resource "digitalocean_droplet" "web" {
  image = "ubuntu-16-04-x64"
  name = "web-1"
  region = "nyc3"
  size = "512mb"
  ipv6 = true
  private_networking = true
  ssh_keys = ["${var.do_ssh_key}"]
}
