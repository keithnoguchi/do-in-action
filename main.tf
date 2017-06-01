# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_TOKEN}"
}

# https://www.terraform.io/docs/providers/do/r/floating_ip.html
resource "digitalocean_floating_ip" "server_flip" {
  droplet_id = "${digitalocean_droplet.server.0.id}"
  region     = "${digitalocean_droplet.server.0.region}"
}

# https://www.terraform.io/docs/providers/do/r/droplet.html
resource "digitalocean_droplet" "server" {
  count              = "${var.server_count}"
  image              = "ubuntu-16-04-x64"
  name               = "server${count.index}"
  region             = "${var.region}"
  size               = "512mb"
  ipv6               = true
  private_networking = true
  ssh_keys           = ["${var.DO_FINGERPRINT}"]
  tags               = ["${digitalocean_tag.server.id}"]

  user_data = <<EOF
#!/bin/bash
apt install -y python
echo "<h1>Hello world from server"${count.index}"</h1>" > index.html
nohup busybox httpd -f -p "${var.server_port}" 0<&- &> /tmp/script.log &
EOF
}

# https://www.terraform.io/docs/providers/do/r/tag.html
resource "digitalocean_tag" "server" {
  name = "server"
}
