output "server" {
  value = "${digitalocean_floating_ip.server_flip.ip_address}"
}
