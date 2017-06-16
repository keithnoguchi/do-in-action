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
  name = "client-999-allow-all"

  tags        = ["${data.terraform_remote_state.main.client_tag_id}"]
  droplet_ids = []

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "1-65535"
      source_addresses   = ["0.0.0.0/0", "::/0"]
      source_tags        = []
      source_droplet_ids = []
    },
    {
      protocol           = "udp"
      port_range         = "1-65535"
      source_addresses   = ["0.0.0.0/0", "::/0"]
      source_tags        = []
      source_droplet_ids = []
    },
    {
      protocol         = "icmp"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
      destination_tags        = []
      destination_droplet_ids = []
    },
    {
      protocol                = "udp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
      destination_tags        = []
      destination_droplet_ids = []
    },
    {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}

resource "digitalocean_firewall" "server_firewall" {
  name = "server-999-allow-all"

  tags        = ["${data.terraform_remote_state.main.server_tag_id}"]
  droplet_ids = []

  inbound_rule = [
    {
      protocol           = "tcp"
      port_range         = "1-65535"
      source_addresses   = ["0.0.0.0/0", "::/0"]
      source_tags        = []
      source_droplet_ids = []
    },
    {
      protocol           = "udp"
      port_range         = "1-65535"
      source_addresses   = ["0.0.0.0/0", "::/0"]
      source_tags        = []
      source_droplet_ids = []
    },
    {
      protocol         = "icmp"
      source_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]

  outbound_rule = [
    {
      protocol                = "tcp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
      destination_tags        = []
      destination_droplet_ids = []
    },
    {
      protocol                = "udp"
      port_range              = "1-65535"
      destination_addresses   = ["0.0.0.0/0", "::/0"]
      destination_tags        = []
      destination_droplet_ids = []
    },
    {
      protocol              = "icmp"
      destination_addresses = ["0.0.0.0/0", "::/0"]
    },
  ]
}
