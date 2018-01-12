output "server_port" {
  value = "${data.terraform_remote_state.root.server_port}"
}

output "client_tag_id" {
  value = "${data.terraform_remote_state.root.client_tag_id}"
}

output "server_tag_id" {
  value = "${data.terraform_remote_state.root.server_tag_id}"
}

output "client_count" {
  value = "${data.terraform_remote_state.root.client_count}"
}

output "server_count" {
  value = "${data.terraform_remote_state.root.server_count}"
}

output "monitor_count" {
  value = "${data.terraform_remote_state.root.monitor_count}"
}

output "client_droplet_id" {
  value = "${data.terraform_remote_state.root.client_droplet_id}"
}

output "client_droplet_region" {
  value = "${data.terraform_remote_state.root.client_droplet_region}"
}

output "client_public_ipv4" {
  value = "${data.terraform_remote_state.root.client_public_ipv4}"
}

output "client_private_ipv4" {
  value = "${data.terraform_remote_state.root.client_private_ipv4}"
}

output "client_public_ipv6" {
  value = "${data.terraform_remote_state.root.client_public_ipv6}"
}

output "server_droplet_id" {
  value = "${data.terraform_remote_state.root.server_droplet_id}"
}

output "server_droplet_region" {
  value = "${data.terraform_remote_state.root.server_droplet_region}"
}

output "server_public_ipv4" {
  value = "${data.terraform_remote_state.root.server_public_ipv4}"
}

output "server_private_ipv4" {
  value = "${data.terraform_remote_state.root.server_private_ipv4}"
}

output "server_public_ipv6" {
  value = "${data.terraform_remote_state.root.server_public_ipv6}"
}

output "server_flip" {
  value = "${data.terraform_remote_state.flips.server_flip}"
}

output "monitor_droplet_id" {
  value = "${data.terraform_remote_state.root.monitor_droplet_id}"
}

output "monitor_droplet_region" {
  value = "${data.terraform_remote_state.root.monitor_droplet_region}"
}

output "monitor_public_ipv4" {
  value = "${data.terraform_remote_state.root.monitor_public_ipv4}"
}

output "monitor_private_ipv4" {
  value = "${data.terraform_remote_state.root.monitor_private_ipv4}"
}

output "monitor_public_ipv6" {
  value = "${data.terraform_remote_state.root.monitor_public_ipv6}"
}
