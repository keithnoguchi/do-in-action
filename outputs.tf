output "server_flip" {
  value = "${digitalocean_floating_ip.server_flip.ip_address}"
}

output "client0_public_ipv4" {
  value = "${digitalocean_droplet.client.0.ipv4_address}"
}

output "client0_public_ipv6" {
  value = "${digitalocean_droplet.client.0.ipv6_address}"
}

output "client1_public_ipv4" {
  value = "${digitalocean_droplet.client.1.ipv4_address}"
}

output "client1_public_ipv6" {
  value = "${digitalocean_droplet.client.1.ipv6_address}"
}

output "client2_public_ipv4" {
  value = "${digitalocean_droplet.client.2.ipv4_address}"
}

output "client2_public_ipv6" {
  value = "${digitalocean_droplet.client.2.ipv6_address}"
}

output "client3_public_ipv4" {
  value = "${digitalocean_droplet.client.3.ipv4_address}"
}

output "client3_public_ipv6" {
  value = "${digitalocean_droplet.client.3.ipv6_address}"
}

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

output "server2_public_ipv4" {
  value = "${digitalocean_droplet.server.2.ipv4_address}"
}

output "server2_public_ipv6" {
  value = "${digitalocean_droplet.server.2.ipv6_address}"
}

output "server3_public_ipv4" {
  value = "${digitalocean_droplet.server.3.ipv4_address}"
}

output "server3_public_ipv6" {
  value = "${digitalocean_droplet.server.3.ipv6_address}"
}
