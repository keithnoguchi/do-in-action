output "server_flip" {
  value = "${digitalocean_floating_ip.server_flip.ip_address}"
}

output "server_port" {
  value = "${var.server_port}"
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

output "client1_public_ipv4" {
  value = "${digitalocean_droplet.client.1.ipv4_address}"
}

output "client1_private_ipv4" {
  value = "${digitalocean_droplet.client.1.ipv4_address_private}"
}

output "client1_public_ipv6" {
  value = "${digitalocean_droplet.client.1.ipv6_address}"
}

output "client2_public_ipv4" {
  value = "${digitalocean_droplet.client.2.ipv4_address}"
}

output "client2_private_ipv4" {
  value = "${digitalocean_droplet.client.2.ipv4_address_private}"
}

output "client2_public_ipv6" {
  value = "${digitalocean_droplet.client.2.ipv6_address}"
}

output "client3_public_ipv4" {
  value = "${digitalocean_droplet.client.3.ipv4_address}"
}

output "client3_private_ipv4" {
  value = "${digitalocean_droplet.client.3.ipv4_address_private}"
}

output "client3_public_ipv6" {
  value = "${digitalocean_droplet.client.3.ipv6_address}"
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

output "server1_public_ipv4" {
  value = "${digitalocean_droplet.server.1.ipv4_address}"
}

output "server1_private_ipv4" {
  value = "${digitalocean_droplet.server.1.ipv4_address_private}"
}

output "server1_public_ipv6" {
  value = "${digitalocean_droplet.server.1.ipv6_address}"
}

output "server2_public_ipv4" {
  value = "${digitalocean_droplet.server.2.ipv4_address}"
}

output "server2_private_ipv4" {
  value = "${digitalocean_droplet.server.2.ipv4_address_private}"
}

output "server2_public_ipv6" {
  value = "${digitalocean_droplet.server.2.ipv6_address}"
}

output "server3_public_ipv4" {
  value = "${digitalocean_droplet.server.3.ipv4_address}"
}

output "server3_private_ipv4" {
  value = "${digitalocean_droplet.server.3.ipv4_address_private}"
}

output "server3_public_ipv6" {
  value = "${digitalocean_droplet.server.3.ipv6_address}"
}
