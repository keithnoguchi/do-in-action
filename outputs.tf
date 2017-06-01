output "server0_public_ipv4" {
  value = "${digitalocean_droplet.server.0.ipv4_address}"
}

output "server0_public_ipv6" {
  value = "${digitalocean_droplet.server.0.ipv6_address}"
}

output "server1_public_ipv4" {
  value = "${digitalocean_droplet.server.1.ipv4_address}"
}

output "server1_public_ipv6" {
  value = "${digitalocean_droplet.server.1.ipv6_address}"
}
