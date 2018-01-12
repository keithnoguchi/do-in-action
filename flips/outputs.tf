output "server_flip" {
  value = ["${digitalocean_floating_ip.server_flip.*.ip_address}"]
}
