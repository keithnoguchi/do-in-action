# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_API_TOKEN}"
}

# https://www.terraform.io/docs/modules/usage.html
module "tags" {
  source = "./tags"
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
  tags               = ["${module.tags.client_tag_id}"]
  user_data          = "${var.DO_CLIENT_USER_DATA}"
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
  tags               = ["${module.tags.server_tag_id}"]
  user_data          = "${var.DO_SERVER_USER_DATA}"
}
