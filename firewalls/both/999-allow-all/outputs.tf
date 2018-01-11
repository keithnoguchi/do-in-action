output "server_flip" {
  value = "${data.terraform_remote_state.flips.server_flip}"
}

output "server_port" {
  value = "${data.terraform_remote_state.root.server_port}"
}

output "client_tag_id" {
  value = "${data.terraform_remote_state.root.client_tag_id}"
}

output "server_tag_id" {
  value = "${data.terraform_remote_state.root.server_tag_id}"
}

output "client0_public_ipv4" {
  value = "${data.terraform_remote_state.root.client0_public_ipv4}"
}

output "client0_private_ipv4" {
  value = "${data.terraform_remote_state.root.client0_private_ipv4}"
}

output "client0_public_ipv6" {
  value = "${data.terraform_remote_state.root.client0_public_ipv6}"
}

output "server0_public_ipv4" {
  value = "${data.terraform_remote_state.root.server0_public_ipv4}"
}

output "server0_private_ipv4" {
  value = "${data.terraform_remote_state.root.server0_private_ipv4}"
}

output "server0_public_ipv6" {
  value = "${data.terraform_remote_state.root.server0_public_ipv6}"
}

output "monitor0_droplet_region" {
  value = "${data.terraform_remote_state.root.monitor0_droplet_region}"
}

output "monitor0_public_ipv4" {
  value = "${data.terraform_remote_state.root.monitor0_public_ipv4}"
}

output "monitor0_private_ipv4" {
  value = "${data.terraform_remote_state.root.monitor0_private_ipv4}"
}

output "monitor0_public_ipv6" {
  value = "${data.terraform_remote_state.root.monitor0_public_ipv6}"
}
