output "server_flip" {
  value = "${data.terraform_remote_state.main.server_flip}"
}

output "server_port" {
  value = "${data.terraform_remote_state.main.server_port}"
}

output "client_tag_id" {
  value = "${data.terraform_remote_state.main.client_tag_id}"
}

output "server_tag_id" {
  value = "${data.terraform_remote_state.main.server_tag_id}"
}

output "client0_public_ipv4" {
  value = "${data.terraform_remote_state.main.client0_public_ipv4}"
}

output "client0_private_ipv4" {
  value = "${data.terraform_remote_state.main.client0_private_ipv4}"
}

output "client0_public_ipv6" {
  value = "${data.terraform_remote_state.main.client0_public_ipv6}"
}

output "server0_public_ipv4" {
  value = "${data.terraform_remote_state.main.server0_public_ipv4}"
}

output "server0_private_ipv4" {
  value = "${data.terraform_remote_state.main.server0_private_ipv4}"
}

output "server0_public_ipv6" {
  value = "${data.terraform_remote_state.main.server0_public_ipv6}"
}
