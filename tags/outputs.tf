output "client_tag_id" {
  value = "${digitalocean_tag.client.id}"
}

output "server_tag_id" {
  value = "${digitalocean_tag.server.id}"
}
