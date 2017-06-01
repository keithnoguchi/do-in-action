# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_TOKEN}"
}

# https://www.terraform.io/docs/providers/do/r/floating_ip.html
resource "digitalocean_floating_ip" "server_fip" {
  droplet_id = "${digitalocean_droplet.server.0.id}"
  region     = "${digitalocean_droplet.server.0.region}"
}

# https://www.terraform.io/docs/providers/do/r/droplet.html
resource "digitalocean_droplet" "server" {
  count              = "${var.server_count}"
  image              = "ubuntu-16-04-x64"
  name               = "server${count.index}"
  region             = "nyc3"
  size               = "512mb"
  ipv6               = true
  private_networking = true
  ssh_keys           = ["${var.DO_FINGERPRINT}"]
  tags               = ["${digitalocean_tag.server.id}"]

  connection {
    user        = "root"
    type        = "ssh"
    private_key = "${var.DO_PRIVATE_KEY}"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get -y install python",
      "apt-get -y install iperf3"
    ]
  }
}

# https://www.terraform.io/docs/providers/do/r/tag.html
resource "digitalocean_tag" "server" {
  name = "server"
}
