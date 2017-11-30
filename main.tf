# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_API_TOKEN}"
}

# https://www.terraform.io/docs/backends/types/local.html
data "terraform_remote_state" "tags" {
  backend = "local"
  config {
    path = "tags/terraform.tfstate"
  }
}

# https://www.terraform.io/docs/backends/types/local.html
data "terraform_remote_state" "flips" {
  backend = "local"
  config {
    path = "flips/terraform.tfstate"
  }
}

# https://www.terraform.io/docs/providers/do/r/droplet.html
resource "digitalocean_droplet" "client" {
  count              = "${var.client_count}"
  image              = "ubuntu-16-04-x64"
  name               = "client${count.index}"
  region             = "${var.DO_REGION}"
  size               = "512mb"
  ipv6               = true
  private_networking = true
  ssh_keys           = ["${var.DO_FINGERPRINT}"]
  tags               = ["${data.terraform_remote_state.tags.client_tag_id}"]

  user_data = <<EOF
#!/bin/bash
apt update && apt install -y python
EOF
}

# https://www.terraform.io/docs/providers/do/r/droplet.html
resource "digitalocean_droplet" "server" {
  count              = "${var.server_count}"
  image              = "ubuntu-16-04-x64"
  name               = "server${count.index}"
  region             = "${var.DO_REGION}"
  size               = "512mb"
  ipv6               = true
  private_networking = true
  ssh_keys           = ["${var.DO_FINGERPRINT}"]
  tags               = ["${data.terraform_remote_state.tags.server_tag_id}"]

  user_data = <<EOF
#!/bin/bash
apt update && apt install -y python
echo "<h1>Hello world from server"${count.index}"</h1>" > index.html
nohup busybox httpd -f -p "${var.server_port}" 0<&- &> /tmp/script.log &
EOF
}

