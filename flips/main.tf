# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_API_TOKEN}"
}

# https://www.terraform.io/docs/backends/types/local.html
data "terraform_remote_state" "main" {
  backend = "local"
  config {
    path = "../terraform.tfstate"
  }
}

# https://www.terraform.io/docs/providers/do/r/floating_ip.html
resource "digitalocean_floating_ip" "server_flip" {
  droplet_id = "${data.terraform_remote_state.main.server0_droplet_id}"
  region     = "${data.terraform_remote_state.main.server0_droplet_region}"
}
