output "server_port" {
  value = "${var.server_port}"
}

output "client_tag_id" {
  value = "${data.terraform_remote_state.tags.client_tag_id}"
}

output "server_tag_id" {
  value = "${data.terraform_remote_state.tags.server_tag_id}"
}

output "client0_droplet_id" {
  value = "${digitalocean_droplet.client.0.id}"
}

output "client0_droplet_region" {
  value = "${digitalocean_droplet.client.0.region}"
}

output "client0_public_ipv4" {
  value = "${digitalocean_droplet.client.0.ipv4_address}"
}

output "client0_private_ipv4" {
  value = "${digitalocean_droplet.client.0.ipv4_address_private}"
}

output "client0_public_ipv6" {
  value = "${digitalocean_droplet.client.0.ipv6_address}"
}

output "server0_droplet_id" {
  value = "${digitalocean_droplet.server.0.id}"
}

output "server0_droplet_region" {
  value = "${digitalocean_droplet.server.0.region}"
}

output "server0_public_ipv4" {
  value = "${digitalocean_droplet.server.0.ipv4_address}"
}

output "server0_private_ipv4" {
  value = "${digitalocean_droplet.server.0.ipv4_address_private}"
}

output "server0_public_ipv6" {
  value = "${digitalocean_droplet.server.0.ipv6_address}"
}
