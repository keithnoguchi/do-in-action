output "public_ipv4" {
  value = "${digitalocean_droplet.web.ipv4_address}"
}

output "public_ipv6" {
  value = "${digitalocean_droplet.web.ipv6_address}"
}
