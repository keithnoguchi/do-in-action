# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_API_TOKEN}"
}

# https://www.terraform.io/docs/backends/types/local.html
data "terraform_remote_state" "main" {
  backend = "local"

  config {
    path = "../../../terraform.tfstate"
  }
}

resource "digitalocean_firewall" "client_firewall" {
  name = "client-000-deny-all"

  tags        = ["${data.terraform_remote_state.main.client_tag_id}"]
  droplet_ids = []

  inbound_rules = [
    {
      # For ansible to work
      protocol           = "tcp"
      port_range         = "22"
      source_addresses   = ["0.0.0.0/0", "::/0"]
      source_tags        = []
      source_droplet_ids = []
    },
  ]

  outbound_rules = [
    {
      # For apt installation
      protocol                = "tcp"
      port_range              = "80"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
      destination_tags        = []
      destination_droplet_ids = []
    },
    {
      # For name resolution
      protocol                = "udp"
      port_range              = "53"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
      destination_tags        = []
      destination_droplet_ids = []
    },
  ]
}
