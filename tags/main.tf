# https://www.terraform.io/docs/providers/do/index.html
provider "digitalocean" {
  token = "${var.DO_API_TOKEN}"
}

# https://www.terraform.io/docs/providers/do/r/tag.html
resource "digitalocean_tag" "client" {
  name = "client-${uuid()}"
  # https://www.terraform.io/docs/configuration/resources.html
  lifecycle {
    ignore_changes = "name"
  }
}

# https://www.terraform.io/docs/providers/do/r/tag.html
resource "digitalocean_tag" "server" {
  name = "server-${uuid()}"
  # https://www.terraform.io/docs/configuration/resources.html
  lifecycle {
    ignore_changes = "name"
  }
}
