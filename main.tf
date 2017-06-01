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
  user_data          = "${data.template_file.server_user_data.rendered}"
}

# https://www.terraform.io/docs/providers/do/r/tag.html
resource "digitalocean_tag" "server" {
  name = "server"
}

data "template_file" "server_user_data" {
  template = "${file("user_data.sh")}"

  vars {
    server_port = "${var.server_port}"
  }
}
