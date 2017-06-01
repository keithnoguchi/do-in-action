# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_TOKEN}"
}

# https://www.terraform.io/docs/providers/do/r/droplet.html
resource "digitalocean_droplet" "server" {
  image              = "ubuntu-16-04-x64"
  name               = "server"
  region             = "nyc3"
  size               = "512mb"
  ipv6               = true
  private_networking = true
  ssh_keys           = ["${var.DO_FINGERPRINT}"]

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
